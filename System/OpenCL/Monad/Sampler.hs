module System.OpenCL.Monad.Sampler
    (clCreateSampler
    ,clRetainSampler
    ,clReleaseSampler
    ,clGetSamplerInfo)
where

import qualified System.OpenCL.Wrappers.Sampler as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types
import Foreign.Ptr(Ptr)


clCreateSampler :: Context -> Bool -> AddressingMode -> FilterMode -> OpenCL Sampler
clCreateSampler ctx normalized_coords amode fmode = 
    ErrorT $ O.clCreateSampler ctx normalized_coords amode fmode

clRetainSampler :: Sampler -> OpenCL () 
clRetainSampler sampler = ErrorT $ O.clRetainSampler sampler

clReleaseSampler :: Sampler -> OpenCL () 
clReleaseSampler sampler = ErrorT $ O.clReleaseSampler sampler

clGetSamplerInfo :: Sampler -> SamplerInfo -> OpenCL CLSamplerInfoRetval
clGetSamplerInfo sampler sinfo =
    ErrorT $ O.clGetSamplerInfo sampler sinfo