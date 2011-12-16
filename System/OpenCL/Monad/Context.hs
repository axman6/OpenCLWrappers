module System.OpenCL.Monads.Context 
    (clCreateContext
    ,clCreateContextFromType
    ,clRetainContext
    ,clReleaseContext
    ,clGetContextInfo
    )
where

import qualified System.OpenCL.Wrappers.Context as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types
import Foreign.Ptr(Ptr)


clCreateContext :: [ContextProperties] -> [DeviceID] -> (Maybe ContextCallback) -> Ptr () -> OpenCL Context
clCreateContext properties devices pfn_notify user_dat =
	ErrorT $ O.clCreateContext properties devices pfn_notify user_dat

          
clCreateContextFromType :: [ContextProperties] -> DeviceType -> (Maybe ContextCallback) -> Ptr () -> OpenCL Context
clCreateContextFromType properties dtype pfn_notify user_data = 
	ErrorT $ O.clCreateContextFromType properties dtype pfn_notify user_data

clRetainContext :: Context -> OpenCL ()
clRetainContext ctx = ErrorT $ O.clReleaseContext ctx

clReleaseContext :: Context -> OpenCL ()
clReleaseContext ctx = ErrorT $ O.clReleaseContext ctx

clGetContextInfo :: Context -> ContextInfo -> OpenCL CLContextInfoRetval
clGetContextInfo ctx (ContextInfo param_name) = 
	ErrorT $ O.clGetContextInfo ctx (ContextInfo param_name)