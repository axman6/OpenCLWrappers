module System.OpenCL.Monad.CommandQueue 
    (clCreateCommandQueue
    ,clRetainCommandQueue
    ,clReleaseCommandQueue
    ,clGetCommandQueueInfo
    ,clSetCommandQueueProperty)
where

import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types
import qualified System.OpenCL.Wrappers.CommandQueue as O

clCreateCommandQueue :: Context -> DeviceID -> [CommandQueueProperties] -> OpenCL CommandQueue
clCreateCommandQueue ctx devid props = 
	ErrorT $ O.clCreateCommandQueue ctx devid props 

clRetainCommandQueue :: CommandQueue -> OpenCL ()
clRetainCommandQueue queue =
	ErrorT $ O.clRetainCommandQueue queue

clReleaseCommandQueue :: CommandQueue -> OpenCL ()
clReleaseCommandQueue queue =
	ErrorT $ O.clReleaseCommandQueue queue

clGetCommandQueueInfo :: CommandQueue -> CommandQueueInfo -> OpenCL CLCommandQueueInfoRetval
clGetCommandQueueInfo ctx qi =
	ErrorT $ O.clGetCommandQueueInfo ctx qi

{-# DEPRECATED clSetCommandQueueProperty "Deprecated in C api" #-}
clSetCommandQueueProperty :: CommandQueue -> CommandQueueProperties -> Bool -> OpenCL CommandQueueProperties
clSetCommandQueueProperty queue props enable =
	ErrorT $ O.clSetCommandQueueProperty queue props enable