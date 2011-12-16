module System.OpenCL.Monad.MemoryObject 
    (clCreateBuffer
    ,clCreateImage2D
    ,clCreateImage3D
    ,clRetainMemObject
    ,clReleaseMemObject
    ,clGetSupportedImageFormats
    ,clGetMemObjectInfo
    ,clGetImageInfo
    ,clEnqueueReadBuffer
    ,clEnqueueWriteBuffer
    ,clEnqueueCopyBuffer
    ,clEnqueueReadImage
    ,clEnqueueWriteImage
    ,clEnqueueCopyImage
    ,clEnqueueCopyImageToBuffer
    ,clEnqueueCopyBufferToImage
    ,clEnqueueMapBuffer
    ,clEnqueueMapImage
    ,clEnqueueUnmapMemObject)
where

import qualified System.OpenCL.Wrappers.MemoryObject as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types
import Foreign.Ptr(Ptr)
import Foreign.Storable


clCreateBuffer :: Context -> MemFlags -> CLsizei -> Ptr () -> OpenCL Mem
clCreateBuffer ctx flags size host_ptr =
    ErrorT $ O.clCreateBuffer ctx flags size host_ptr
              
clCreateImage2D :: Context -> MemFlags -> ImageFormat -> CLsizei -> CLsizei -> CLsizei -> Ptr () -> OpenCL Mem
clCreateImage2D ctx flags format image_width image_height image_row_pitch host_ptr = 
    ErrorT $ O.clCreateImage2D ctx flags format image_width image_height image_row_pitch host_ptr
                        
clCreateImage3D :: Context -> MemFlags -> ImageFormat -> CLsizei -> CLsizei -> CLsizei -> CLsizei -> CLsizei -> Ptr () -> OpenCL Mem
clCreateImage3D ctx flags format image_width image_height image_depth image_row_pitch image_slice_pitch host_ptr = 
    ErrorT $ O.clCreateImage3D ctx flags format image_width image_height image_depth image_row_pitch image_slice_pitch host_ptr
                        
clRetainMemObject :: Mem -> OpenCL () 
clRetainMemObject mem = ErrorT $ O.clRetainMemObject mem

clReleaseMemObject :: Mem -> OpenCL () 
clReleaseMemObject mem = ErrorT $ O.clReleaseMemObject mem
                                    
clGetSupportedImageFormats :: Context -> MemFlags -> MemObjectType -> OpenCL [ImageFormat]
clGetSupportedImageFormats ctx flags type' =
    ErrorT $ O.clGetSupportedImageFormats ctx flags type'

clGetMemObjectInfo :: Mem -> MemInfo -> OpenCL CLMemObjectInfoRetval
clGetMemObjectInfo mem info = 
    ErrorT $ O.clGetMemObjectInfo mem info

clGetImageInfo :: Mem -> MemInfo -> OpenCL CLImageInfoRetval
clGetImageInfo mem info =
    ErrorT $ O.clGetImageInfo mem info
        
-- enqueue :: (CommandQueue -> CLuint -> Ptr Event -> Ptr Event -> IO CLint) -> CommandQueue -> [Event] -> OpenCL Event      
-- enqueue fn queue events =
--     ErrorT $ O.enqueue fn queue events
    
clEnqueueReadBuffer :: Mem -> Bool -> CLsizei -> CLsizei -> Ptr () -> CommandQueue -> [Event] -> OpenCL Event
clEnqueueReadBuffer buffer blocking_read offset cb ptr queue events = 
    ErrorT $ O.clEnqueueReadBuffer buffer blocking_read offset cb ptr queue events

clEnqueueWriteBuffer :: Mem -> Bool -> CLsizei -> CLsizei -> Ptr () -> CommandQueue -> [Event] -> OpenCL Event
clEnqueueWriteBuffer buffer blocking_write offset cb ptr queue events = 
    ErrorT $ O.clEnqueueWriteBuffer buffer blocking_write offset cb ptr queue events

clEnqueueCopyBuffer :: Mem -> Mem -> CLsizei -> CLsizei -> CLsizei -> CommandQueue -> [Event] -> OpenCL Event
clEnqueueCopyBuffer src_buffer dst_buffer src_offset dst_offset cb queue events = 
    ErrorT $ O.clEnqueueCopyBuffer src_buffer dst_buffer src_offset dst_offset cb queue events
    
clEnqueueReadImage :: Mem -> Bool -> ImageDims -> ImageDims -> CLsizei -> CLsizei -> Ptr () -> CommandQueue -> [Event] -> OpenCL Event
clEnqueueReadImage image blocking_read (oa,ob,oc) (ra,rb,rc) row_pitch slice_pitch ptr queue events = 
    ErrorT $ O.clEnqueueReadImage image blocking_read (oa,ob,oc) (ra,rb,rc) row_pitch slice_pitch ptr queue events
   
clEnqueueWriteImage :: Mem -> Bool -> ImageDims -> ImageDims -> CLsizei -> CLsizei -> Ptr () -> CommandQueue -> [Event] -> OpenCL Event
clEnqueueWriteImage image blocking_read (oa,ob,oc) (ra,rb,rc) row_pitch slice_pitch ptr queue events = 
    ErrorT $ O.clEnqueueWriteImage image blocking_read (oa,ob,oc) (ra,rb,rc) row_pitch slice_pitch ptr queue events

clEnqueueCopyImage :: Mem -> Mem -> ImageDims -> ImageDims -> ImageDims -> CommandQueue -> [Event] -> OpenCL Event  
clEnqueueCopyImage src_image dst_image dima dimb dimc queue events = 
    ErrorT $ O.clEnqueueCopyImage src_image dst_image dima dimb dimc queue events

                           
clEnqueueCopyImageToBuffer :: Mem -> Mem -> ImageDims -> ImageDims -> CLsizei -> CommandQueue -> [Event] -> OpenCL Event  
clEnqueueCopyImageToBuffer src_image dst_buffer dims dimr dst_offset queue events = 
    ErrorT $ O.clEnqueueCopyImageToBuffer src_image dst_buffer dims dimr dst_offset queue events


clEnqueueCopyBufferToImage :: Mem -> Mem -> CLsizei -> ImageDims -> ImageDims -> CommandQueue -> [Event] -> OpenCL Event  
clEnqueueCopyBufferToImage src_buffer dst_image src_offset dims dimr queue events = 
    ErrorT $ O.clEnqueueCopyBufferToImage src_buffer dst_image src_offset dims dimr queue events


clEnqueueMapBuffer :: Mem -> Bool -> MapFlags -> CLsizei -> CLsizei -> CommandQueue -> [Event] -> OpenCL (Ptr (),Event)
clEnqueueMapBuffer buffer blocking_map flags offset cb command_queue events = 
    ErrorT $ O.clEnqueueMapBuffer buffer blocking_map flags offset cb command_queue events

clEnqueueMapImage :: Mem -> Bool -> MapFlags -> ImageDims -> ImageDims -> CommandQueue -> [Event] -> OpenCL (Ptr (),CLsizei,CLsizei,Event)
clEnqueueMapImage buffer blocking_map flags dimo dimr command_queue events = 
    ErrorT $ O.clEnqueueMapImage buffer blocking_map flags dimo dimr command_queue events
                  

clEnqueueUnmapMemObject mem mapped_ptr queue events =
    ErrorT $ O.clEnqueueUnmapMemObject mem mapped_ptr queue events