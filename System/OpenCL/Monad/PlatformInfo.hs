module System.OpenCL.Monad.PlatformInfo (
    clGetPlatformIDs
  , clGetPlatformInfo
  ) where

import qualified System.OpenCL.Wrappers.PlatformInfo as O
import System.OpenCL.Wrappers.Types
import System.OpenCL.Monad.Types


clGetPlatformIDs :: OpenCL [PlatformID]
clGetPlatformIDs = ErrorT $ O.clGetPlatformIDs

clGetPlatformInfo :: PlatformID -> PlatformInfo -> OpenCL CLPlatformInfoRetval
clGetPlatformInfo mem pi = ErrorT $ O.clGetPlatformInfo mem pi
