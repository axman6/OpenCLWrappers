module System.OpenCL.Monad.Types (OpenCL, ErrorT(..), liftIO, lift, runOpenCL) where

import Control.Monad.Error (ErrorT(..), runErrorT, liftIO, lift)
import System.OpenCL.Wrappers.Types (ErrorCode)

type OpenCL a = ErrorT ErrorCode IO a

runOpenCL :: OpenCL a -> IO (Either ErrorCode a)
runOpenCL = runErrorT



