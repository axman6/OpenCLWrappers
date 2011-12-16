{-| Module for querying extensions -}
module System.OpenCL.Monad.Etc 
    (clGetExtensionFunctionAddress)
where

import qualified System.OpenCL.Wrappers.Etc as O
import System.OpenCL.Monad.Types
import Foreign.Ptr(Ptr)


clGetExtensionFunctionAddress :: String -> OpenCL (Ptr ())
clGetExtensionFunctionAddress str = 
	ErrorT $ fmap Right (O.clGetExtensionFunctionAddress str)
