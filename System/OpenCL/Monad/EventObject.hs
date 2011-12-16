module System.OpenCL.Monad.EventObject 
    (clWaitForEvents
    ,clGetEventInfo
    ,clRetainEvent
    ,clReleaseEvent
    ,clGetEventProfilingInfo)
where 

import qualified System.OpenCL.Wrappers.EventObject as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types


clWaitForEvents :: [Event] -> OpenCL ()
clWaitForEvents evts =
	ErrorT $ O.clWaitForEvents evts
                            
clGetEventInfo :: Event -> EventInfo -> OpenCL CLEventInfoRetval
clGetEventInfo obj ei = 
	ErrorT $ O.clGetEventInfo obj ei

clRetainEvent :: Event -> OpenCL ()
clRetainEvent evt = ErrorT $ O.clReleaseEvent evt

clReleaseEvent :: Event -> OpenCL ()
clReleaseEvent evt = ErrorT $ O.clReleaseEvent evt

clGetEventProfilingInfo :: Event -> ProfilingInfo -> OpenCL CLEventProfilingInfoRetval
clGetEventProfilingInfo obj pi = 
	ErrorT $ O.clGetEventProfilingInfo obj pi