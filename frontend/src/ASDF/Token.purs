module ASDF.Token
    ( Token (..)
    ) where

import Prelude

import Data.Newtype (class Newtype)

newtype Token =
    Token String

derive instance eqToken :: Eq Token
derive instance ordToken :: Ord Token
derive instance newtypeToken :: Newtype Token _
instance showToken :: Show Token where show _ = "(Token <REDACTED>)"
