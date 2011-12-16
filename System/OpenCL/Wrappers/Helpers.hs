{-# LANGUAGE ExistentialQuantification #-}
{-| Some helper functions that may or may not be useful to anyone. -}
module System.OpenCL.Wrappers.Helpers
    (createSyncKernel
    ,createAsyncKernelWithParams
    ,buildProgram
    ,pushKernelParams)
where

import System.OpenCL.Wrappers.Kernel
import System.OpenCL.Wrappers.Types
import System.OpenCL.Wrappers.ProgramObject
import System.OpenCL.Wrappers.FlushFinish
import System.OpenCL.Wrappers.Utils (handleEither)
import Foreign.Marshal
import Foreign.Storable
import Foreign.Ptr

pushKernelParams :: forall b. Storable b => Kernel -> CLuint -> [b] -> IO (Either ErrorCode ())
pushKernelParams kernel argNum (x:xs) = do
    err <- withArray [x] $ \y ->
		clSetKernelArg kernel argNum (fromIntegral.sizeOf $ x) (castPtr y)
    handleEither err $ \_ -> pushKernelParams kernel (argNum + 1) xs
pushKernelParams _ _ _ = return $ Right ()

syncKernelFun :: forall b. Storable b => CLuint -> Kernel -> CommandQueue -> [CLsizei] -> [CLsizei] -> [b] -> IO (Either ErrorCode ())
syncKernelFun _ kernel queue a b [] = do
        err <- clEnqueueNDRangeKernel queue kernel a b []
        handleEither err $ \_ -> clFinish queue
syncKernelFun argNum kernel queue a b (x:xs) = do
        err <- withArray [x] (\y -> clSetKernelArg kernel argNum (fromIntegral.sizeOf $ x) (castPtr y))
        handleEither err $ \_ -> syncKernelFun (argNum + 1) kernel queue a b xs

createSyncKernel :: forall b. Storable b => Program -> CommandQueue -> String -> [Int] -> [Int] -> IO (Either ErrorCode ([b] -> IO (Either ErrorCode ())))
createSyncKernel program queue initFun globalWorkRange localWorkRange = do
        err <- clCreateKernel program initFun
        handleEither err $ \k ->
			return.Right $ syncKernelFun 0 k queue (map fromIntegral globalWorkRange) (map fromIntegral localWorkRange)

createAsyncKernelWithParams :: forall b. Storable b => Program -> CommandQueue -> String -> [Int] -> [Int] -> [b] -> IO (Either ErrorCode ([Event] -> IO (Either ErrorCode Event)))
createAsyncKernelWithParams program queue initFun globalWorkRange localWorkRange params = do
        err <- clCreateKernel program initFun
        handleEither err $ \k -> do
            err <- pushKernelParams k 0 params
            handleEither err $ \_ ->
		    	return.Right $ clEnqueueNDRangeKernel queue k (map fromIntegral globalWorkRange)
		    												  (map fromIntegral localWorkRange)

buildProgram :: String -> String -> Context -> DeviceID -> IO (Either (ErrorCode, String) Program)
buildProgram source opts context dID = do
    err <- clCreateProgramWithSource context source
    case err of
        Left err -> return $ Left (err,"buildProgram: failure from clCreateProgramWithSource")
        Right program -> do
            err <- clBuildProgram program [dID] opts Nothing nullPtr
            case err of
                Left x -> do
                    y <- fmap Left $ reportBuildFailure program dID x
                    _ <- clReleaseProgram program
                    return (y :: Either (ErrorCode,String) Program)
                Right _ -> return $ Right program


reportBuildFailure :: Program -> DeviceID -> ErrorCode -> IO (ErrorCode,String)
reportBuildFailure program dID eCode = do
    err <- clGetProgramBuildInfo program dID clProgramBuildLog
    case err of
        Left x -> return (x,"")
        Right x -> case x of
            (ProgramBuildInfoRetvalString s)
                -> return (eCode,s)
            _   -> error $ "reportBuildFailure: something went wrong (clGetProgramBuildInfo didn't return ProgramBuildInfoRetvalString)" 


