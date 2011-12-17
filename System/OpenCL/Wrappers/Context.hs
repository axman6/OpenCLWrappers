module System.OpenCL.Wrappers.Context 
    (clCreateContext
    ,clCreateContextFromType
    ,clRetainContext
    ,clReleaseContext
    ,clGetContextInfo
    )
where

import System.OpenCL.Wrappers.Types
import System.OpenCL.Wrappers.Utils
import System.OpenCL.Wrappers.Raw
import Foreign.Ptr(Ptr, nullPtr, nullFunPtr)
import Foreign.Marshal.Array(withArray)


clCreateContext :: [ContextProperties] -> [DeviceID] -> (Maybe ContextCallback) -> Ptr () -> IO (Either ErrorCode Context)
clCreateContext [] devices pfn_notify user_dat = do
    withArray devices $ \devicesP -> do
        fptr <- maybe (return nullFunPtr) wrapContextCallback pfn_notify
        wrapErrorEither $ raw_clCreateContext nullPtr (fromIntegral devicesN) devicesP fptr user_dat
    where devicesN = length devices


clCreateContext properties devices pfn_notify user_dat = do
    withArrayNull0 nullPtr properties $ \propertiesP -> do
        withArray devices $ \devicesP -> do
            fptr <- maybe (return nullFunPtr) wrapContextCallback pfn_notify
            wrapErrorEither $ raw_clCreateContext propertiesP (fromIntegral devicesN) devicesP fptr user_dat             
    where devicesN = length devices
          
clCreateContextFromType :: [ContextProperties] -> DeviceType -> (Maybe ContextCallback) -> Ptr () -> IO (Either ErrorCode Context)
clCreateContextFromType [] (DeviceType device_type) pfn_notify user_data = do
    fptr <- maybe (return nullFunPtr) wrapContextCallback pfn_notify
    wrapErrorEither $ raw_clCreateContextFromType nullPtr device_type fptr user_data

clCreateContextFromType properties (DeviceType device_type) pfn_notify user_data = withArrayNull0 nullPtr properties $ \propertiesP -> do
    fptr <- maybe (return nullFunPtr) wrapContextCallback pfn_notify
    wrapErrorEither $ raw_clCreateContextFromType propertiesP device_type fptr user_data
    
clRetainContext :: Context -> IO (Either ErrorCode ())
clRetainContext ctx = wrapError (raw_clRetainContext ctx)

clReleaseContext :: Context -> IO (Either ErrorCode ())
clReleaseContext ctx = wrapError (raw_clReleaseContext ctx)

clGetContextInfo :: Context -> ContextInfo -> IO (Either ErrorCode CLContextInfoRetval)
clGetContextInfo ctx (ContextInfo param_name) = wrapGetInfo (raw_clGetContextInfo ctx param_name) >>=
        either (return.Left) (\(x,size) -> fmap Right $ let c = (ContextInfo param_name) in case () of 
        ()
            | c == clContextReferenceCount -> peekOneInfo ContextInfoRetvalCLuint x
            | c == clContextDevices        -> peekManyInfo ContextInfoRetvalDeviceIDList x size
            | c == clContextProperties     -> peekManyInfo ContextInfoRetvalContextPropertiesList x size )
