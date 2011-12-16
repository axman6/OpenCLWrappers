module System.OpenCL.Wrappers.ProgramObject 
    (clCreateProgramWithSource
    ,clCreateProgramWithBinary
    ,clRetainProgram
    ,clReleaseProgram
    ,clBuildProgram
    ,clUnloadCompiler
    ,clGetProgramInfo
    ,clGetProgramBuildInfo)
where

import Control.Monad.Cont
import System.OpenCL.Wrappers.Types
import System.OpenCL.Wrappers.Errors
import System.OpenCL.Wrappers.Utils
import System.OpenCL.Wrappers.Raw
import Foreign hiding (unsafeForeignPtrToPtr)
import Foreign.ForeignPtr.Unsafe (unsafeForeignPtrToPtr)
import Foreign.C
import Control.Applicative
import qualified Data.ByteString as SBS
import qualified Data.ByteString.Internal as SBS

clCreateProgramWithSource :: Context -> String -> IO (Either ErrorCode Program) 
clCreateProgramWithSource ctx source_code = do
    let count = length strings
        strings = lines source_code
        lengths = (fromIntegral . length) <$> strings
    withArray lengths $ (\lengthsP -> 
        withCStringArray0 strings $ (\stringsP -> 
            wrapErrorEither $ raw_clCreateProgramWithSource ctx (fromIntegral count) stringsP lengthsP))   

clCreateProgramWithBinary :: Context -> [(DeviceID,SBS.ByteString)] ->  IO (Either ErrorCode Program)
clCreateProgramWithBinary context devbin_pair = 
    allocaArray num_devices $ \lengths -> 
    allocaArray num_devices $ \binaries ->
    allocaArray num_devices $ \devices -> 
    alloca $ \binary_status ->
    alloca $ \errcode_ret -> do
        pokeArray lengths (map (fromIntegral . SBS.length) bins)
        pokeArray devices device_list
        pokeArray binaries ((unsafeForeignPtrToPtr . bsPtr) `map` bins) 
        program <- raw_clCreateProgramWithBinary context (fromIntegral num_devices) devices lengths binaries binary_status errcode_ret
        errcode <- ErrorCode <$> peek errcode_ret
        binstatus <- ErrorCode <$> peek binary_status
        if errcode == clSuccess && binstatus == clSuccess
            then return $ Right program
            else return $ Left (if errcode == clSuccess then binstatus else errcode)
    where bsPtr (SBS.PS p _ _) = p
          num_devices = length device_list
          (device_list,bins) = unzip devbin_pair
        
clRetainProgram :: Program -> IO (Either ErrorCode ()) 
clRetainProgram prog = wrapError $ raw_clRetainProgram prog

clReleaseProgram :: Program -> IO (Either ErrorCode ()) 
clReleaseProgram prog = wrapError $ raw_clReleaseProgram prog

clBuildProgram :: Program -> [DeviceID] -> String -> (Maybe BuildProgramCallback) -> Ptr () -> IO (Either ErrorCode ())
clBuildProgram program devices ops pfn_notifyF user_data = 
    allocaArray num_devices $ \device_list -> 
    withCString ops $ \options -> do 
        pokeArray device_list devices
        pfn_notify <- maybe (return nullFunPtr) wrapBuildProgramCallback pfn_notifyF
        wrapError $ raw_clBuildProgram program (fromIntegral num_devices) device_list options pfn_notify user_data
    where num_devices = length devices   

clUnloadCompiler :: IO (Either ErrorCode ())
clUnloadCompiler = wrapError $ raw_clUnloadCompiler

clGetProgramInfo :: Program -> ProgramInfo -> IO (Either ErrorCode CLProgramInfoRetval)
clGetProgramInfo program (ProgramInfo param_name) = (wrapGetInfo $ raw_clGetProgramInfo program param_name) >>=
    either (return.Left) (\(x,size) -> fmap Right $ let c = (ProgramInfo param_name) in case () of 
        ()
            | c == clProgramReferenceCount -> peekOneInfo ProgramInfoRetvalCLUint x
            | c == clProgramContext        -> peekOneInfo ProgramInfoRetvalContext x
            | c == clProgramNumDevices     -> peekOneInfo ProgramInfoRetvalCLUint x
            | c == clProgramDevices        -> peekManyInfo ProgramInfoRetvalDeviceIDList x size
            | c == clProgramSource         -> peekStringInfo ProgramInfoRetvalString x
            | c == clProgramBinarySizes    -> peekManyInfo ProgramInfoRetvalCLsizeiList x size
            | c == clProgramBinaries       -> peekManyInfo ProgramInfoRetvalPtrList x size )

clGetProgramBuildInfo :: Program -> DeviceID -> ProgramBuildInfo -> IO (Either ErrorCode CLProgramBuildInfoRetval)
clGetProgramBuildInfo program devID (ProgramBuildInfo param_name) = (wrapGetInfo $ raw_clGetProgramBuildInfo program devID param_name) >>=
    either (return.Left) (\(x,_) -> fmap Right $ let c = (ProgramBuildInfo param_name) in case () of
        ()
            | c == clProgramBuildStatus -> peekOneInfo (ProgramBuildInfoRetvalBuildStatus . BuildStatus) x
            | True                      -> peekStringInfo (ProgramBuildInfoRetvalString) x )
