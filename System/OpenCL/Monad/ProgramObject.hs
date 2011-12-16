module System.OpenCL.Monad.ProgramObject 
    (clCreateProgramWithSource
    ,clCreateProgramWithBinary
    ,clRetainProgram
    ,clReleaseProgram
    ,clBuildProgram
    ,clUnloadCompiler
    ,clGetProgramInfo
    ,clGetProgramBuildInfo)
where

import qualified System.OpenCL.Wrappers.ProgramObject as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types
import qualified Data.ByteString as SBS
import Foreign.Ptr(Ptr)


clCreateProgramWithSource :: Context -> String -> OpenCL Program 
clCreateProgramWithSource ctx source_code = ErrorT $ O.clCreateProgramWithSource ctx source_code

clCreateProgramWithBinary :: Context -> [(DeviceID,SBS.ByteString)] ->  OpenCL Program
clCreateProgramWithBinary context devbin_pair = 
    ErrorT $ O.clCreateProgramWithBinary context devbin_pair
        
clRetainProgram :: Program -> OpenCL () 
clRetainProgram prog = ErrorT $ O.clRetainProgram prog

clReleaseProgram :: Program -> OpenCL () 
clReleaseProgram prog = ErrorT $ O.clReleaseProgram prog

clBuildProgram :: Program -> [DeviceID] -> String -> (Maybe BuildProgramCallback) -> Ptr () -> OpenCL ()
clBuildProgram program devices ops pfn_notifyF user_data = 
    ErrorT $ O.clBuildProgram program devices ops pfn_notifyF user_data

clUnloadCompiler :: OpenCL ()
clUnloadCompiler = ErrorT $ O.clUnloadCompiler

clGetProgramInfo :: Program -> ProgramInfo -> OpenCL CLProgramInfoRetval
clGetProgramInfo program pi =
    ErrorT $ O.clGetProgramInfo program pi

clGetProgramBuildInfo :: Program -> DeviceID -> ProgramBuildInfo -> OpenCL CLProgramBuildInfoRetval
clGetProgramBuildInfo program devID pbi =
    ErrorT $ O.clGetProgramBuildInfo program devID pbi
