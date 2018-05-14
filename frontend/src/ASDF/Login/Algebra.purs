module ASDF.Login.Algebra
    ( Login (..)
    , login
    ) where

import Prelude

import ASDF.Credentials (EmailAddress, Password)
import ASDF.Token (Token)
import Control.Monad.Free (Free, liftF)
import Data.Maybe (Maybe)

data Login a =
    Login (Maybe Token -> a) EmailAddress Password

login :: EmailAddress -> Password -> Free Login (Maybe Token)
login = (liftF <<< _) <<< Login id
