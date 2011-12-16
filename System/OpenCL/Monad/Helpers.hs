{-# LANGUAGE ExistentialQuantification #-}
{-| Some helper functions that may or may not be useful to anyone. -}
module System.OpenCL.Monad.Helpers
    (
    --createAsyncKernelWithParams
    --,createSyncKernel -- Left out because the types are too hard
    buildProgram
    ,pushKernelParams)
where

import qualified System.OpenCL.Wrappers.Helpers as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types
import Foreign.Ptr(Ptr)
import Foreign.Storable


pushKernelParams :: forall b. Storable b => Kernel -> CLuint -> [b] -> OpenCL ()
pushKernelParams kernel argNum xs =
    ErrorT $ O.pushKernelParams kernel argNum xs


{-
    TODO Make these functions work
-}

-- createSyncKernel :: forall b. Storable b => Program -> CommandQueue -> String -> [Int] -> [Int]
-- -> IO (Either ErrorCode ([b] -> IO (Either ErrorCode ())))
-- createSyncKernel :: forall b. Storable b => Program -> CommandQueue -> String -> [Int] -> [Int]
    -- -> OpenCL ([b] -> OpenCL ())
-- createSyncKernel program queue initFun globalWorkRange localWorkRange = 
--     ErrorT $ do
--         err <- O.createSyncKernel program queue initFun globalWorkRange localWorkRange :: IO (Either ErrorCode ([b] -> IO (Either ErrorCode ())))
--         case err of
--             Left err -> return $ Left err
--             Right f  -> return $ Right (ErrorT . f)
-- 
-- createAsyncKernelWithParams :: forall b. Storable b => Program -> CommandQueue -> String -> [Int] -> [Int] -> [b] -> OpenCL ([Event] -> OpenCL Event)
-- createAsyncKernelWithParams program queue initFun globalWorkRange localWorkRange params = 
--     ErrorT $ do O.createAsyncKernelWithParams program queue initFun globalWorkRange localWorkRange params

buildProgram :: String -> String -> Context -> DeviceID -> OpenCL (Either (ErrorCode, String) Program)
buildProgram source opts context dID = ErrorT $ fmap Right $ O.buildProgram source opts context dID


