module System.OpenCL.Monad.Kernel 
    (clCreateKernel
    ,clCreateKernelsInProgram
    ,clRetainKernel
    ,clReleaseKernel
    ,clGetKernelInfo
    ,clSetKernelArg
    ,clGetKernelWorkGroupInfo
    ,clEnqueueNDRangeKernel
    ,clEnqueueTask
    ,clEnqueueNativeKernel)
where

import qualified System.OpenCL.Wrappers.Kernel as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types
import Foreign.Ptr(Ptr)



clCreateKernel :: Program -> String -> OpenCL Kernel
clCreateKernel program init_name = ErrorT $ O.clCreateKernel program init_name

clCreateKernelsInProgram :: Program -> CLuint -> OpenCL [Kernel]
clCreateKernelsInProgram program num_kernels =
    ErrorT $ O.clCreateKernelsInProgram program num_kernels

clRetainKernel :: Kernel -> OpenCL ()
clRetainKernel kernel =
    ErrorT $ O.clRetainKernel kernel

clReleaseKernel :: Kernel -> OpenCL ()
clReleaseKernel kernel =
    ErrorT $ O.clReleaseKernel kernel

clSetKernelArg :: Kernel -> CLuint -> CLsizei -> Ptr () -> OpenCL ()
clSetKernelArg kernel arg_index arg_size arg_value = 
    ErrorT $ O.clSetKernelArg kernel arg_index arg_size arg_value
    
clGetKernelInfo :: Kernel -> KernelInfo -> OpenCL CLKernelInfoRetval
clGetKernelInfo kernel (KernelInfo param_name) =
    ErrorT $ O.clGetKernelInfo kernel (KernelInfo param_name)

clGetKernelWorkGroupInfo :: Kernel -> DeviceID -> KernelWorkGroupInfo -> OpenCL CLKernelWorkGroupInfoRetval
clGetKernelWorkGroupInfo kernel device kwgi =
    ErrorT $ O.clGetKernelWorkGroupInfo kernel device kwgi

clEnqueueNDRangeKernel :: CommandQueue -> Kernel -> [CLsizei] -> [CLsizei] -> [Event] -> OpenCL Event 
clEnqueueNDRangeKernel queue kernel global_work_sizeL local_work_sizeL event_wait_listL = 
    ErrorT $ O.clEnqueueNDRangeKernel queue kernel global_work_sizeL local_work_sizeL event_wait_listL
        
clEnqueueTask :: CommandQueue -> Kernel -> [Event] -> OpenCL Event
clEnqueueTask queue kernel event_wait_listL = 
    ErrorT $ O.clEnqueueTask queue kernel event_wait_listL

clEnqueueNativeKernel :: NativeKernelCallback -> Ptr () -> CLsizei -> [Mem] -> [Ptr ()] -> [Event] -> OpenCL Event
clEnqueueNativeKernel user_funcF args cb_args mem_listL args_mem_locL event_wait_listL = 
    ErrorT $ O.clEnqueueNativeKernel user_funcF args cb_args mem_listL args_mem_locL event_wait_listL
