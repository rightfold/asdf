module ASDF.Login
    ( Login (..)
    , login

    , EmailAddress (..)
    , Password (..)
    ) where

import Prelude

import ASDF.Authenticate (Token)
import Control.Monad.Free (Free, liftF)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

data Login a =
    Login (Maybe Token -> a) EmailAddress Password

login :: EmailAddress -> Password -> Free Login (Maybe Token)
login = (liftF <<< _) <<< Login id

newtype EmailAddress =
    EmailAddress String

derive instance eqEmailAddress :: Eq EmailAddress
derive instance ordEmailAddress :: Ord EmailAddress
derive instance newtypeEmailAddress :: Newtype EmailAddress _
derive instance genericEmailAddress :: Generic EmailAddress _
instance showEmailAddress :: Show EmailAddress where show = genericShow

newtype Password =
    Password String

derive instance eqPassword :: Eq Password
derive instance ordPassword :: Ord Password
derive instance newtypePassword :: Newtype Password _
instance showPassword :: Show Password where show _ = "(Password <REDACTED>)"
