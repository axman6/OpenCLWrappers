module System.OpenCL.Monad.Types (OpenCL, ErrorT(..), liftIO) where

import Control.Monad.Error (ErrorT(..), runErrorT, liftIO)
import System.OpenCL.Wrappers.Types (ErrorCode)

type OpenCL a = ErrorT ErrorCode IO a

runOpenCL :: OpenCL a -> IO (Either ErrorCode a)
runOpenCL = runErrorT



