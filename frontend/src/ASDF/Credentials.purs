module ASDF.Credentials
    ( EmailAddress (..)
    , Password (..)
    ) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)

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

