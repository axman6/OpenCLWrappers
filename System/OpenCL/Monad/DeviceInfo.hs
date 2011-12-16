module System.OpenCL.Monads.DeviceInfo
    (clGetDeviceIDs
    ,clGetDeviceInfo)
where

import qualified System.OpenCL.Wrappers.DeviceInfo as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types



clGetDeviceIDs :: PlatformID -> DeviceType -> OpenCL [DeviceID]
clGetDeviceIDs platform dtype =
	ErrorT $ O.clGetDeviceIDs platform dtype

clGetDeviceInfo :: DeviceID -> DeviceInfo -> OpenCL CLDeviceInfoRetval
clGetDeviceInfo obj di = 
	ErrorT $ O.clGetDeviceInfo obj di
