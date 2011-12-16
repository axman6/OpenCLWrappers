
import Control.Monad.Error

type OpenCL a = ErrorT ErrorCode IO a

