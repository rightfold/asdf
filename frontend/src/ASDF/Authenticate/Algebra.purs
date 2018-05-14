module ASDF.Authenticate.Algebra
    ( Authenticate (..)
    , getToken
    , putToken
    , deleteToken
    ) where

import Prelude

import ASDF.Token (Token)
import Control.Monad.Free (Free, liftF)
import Data.Maybe (Maybe)

data Authenticate a
    = GetToken (Maybe Token -> a)
    | PutToken a Token
    | DeleteToken a

getToken :: Free Authenticate (Maybe Token)
getToken = liftF $ GetToken id

putToken :: Token -> Free Authenticate Unit
putToken = liftF <<< PutToken unit

deleteToken :: Free Authenticate Unit
deleteToken = liftF $ DeleteToken unit
