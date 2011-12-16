module System.OpenCL.Wrappers.OutOfOrder
    (clEnqueueMarker
    ,clEnqueueWaitForEvents
    ,clEnqueueBarrier)
where 

import System.OpenCL.Wrappers.Types
import System.OpenCL.Wrappers.Utils
import System.OpenCL.Wrappers.Raw
import Foreign(withArray,peek,alloca)

clEnqueueMarker :: CommandQueue -> IO (Either ErrorCode Event)
clEnqueueMarker queue = alloca $ \eventP -> do
    err <- wrapError (raw_clEnqueueMarker queue eventP)
    handleEither err $ \_ -> fmap Right $ peek eventP
    
clEnqueueWaitForEvents :: CommandQueue -> [Event] -> IO (Either ErrorCode ())
clEnqueueWaitForEvents queue events =
    withArray events (\eventsP ->
        wrapError $ raw_clEnqueueWaitForEvents queue (fromIntegral num_events) eventsP)
    where num_events = length events

clEnqueueBarrier :: CommandQueue -> IO (Either ErrorCode ()) 
clEnqueueBarrier queue = wrapError $ raw_clEnqueueBarrier queue
