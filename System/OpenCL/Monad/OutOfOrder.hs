module System.OpenCL.Monad.OutOfOrder
    (clEnqueueMarker
    ,clEnqueueWaitForEvents
    ,clEnqueueBarrier)
where 

import qualified System.OpenCL.Wrappers.OutOfOrder as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types

clEnqueueMarker :: CommandQueue -> OpenCL Event
clEnqueueMarker queue = ErrorT $ O.clEnqueueMarker queue
    
clEnqueueWaitForEvents :: CommandQueue -> [Event] -> OpenCL ()
clEnqueueWaitForEvents queue events = ErrorT $ O.clEnqueueWaitForEvents queue events

clEnqueueBarrier :: CommandQueue -> OpenCL () 
clEnqueueBarrier queue = ErrorT $ O.clEnqueueBarrier queue
