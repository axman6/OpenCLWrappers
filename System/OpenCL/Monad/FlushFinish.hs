module System.OpenCL.Monad.FlushFinish 
    (clFlush
    ,clFinish)
where

import qualified System.OpenCL.Wrappers.FlushFinish as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types


clFlush :: CommandQueue -> OpenCL ()
clFlush queue = ErrorT $ O.clFlush queue

clFinish :: CommandQueue -> OpenCL ()
clFinish queue = ErrorT $ O.clFinish queue
