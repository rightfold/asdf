module ASDF.Authenticate
    ( Authenticate (..)
    , getToken
    , putToken
    , deleteToken

    , Token (..)
    ) where

import Prelude

import Control.Monad.Free (Free, liftF)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

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

newtype Token =
    Token String

derive instance eqToken :: Eq Token
derive instance ordToken :: Ord Token
derive instance newtypeToken :: Newtype Token _
instance showToken :: Show Token where show _ = "(Token <REDACTED>)"
