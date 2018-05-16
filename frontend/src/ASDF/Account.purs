module ASDF.Account
    ( AccountID (..)
    ) where

import Prelude

import Data.Argonaut.Decode (class DecodeJson)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)

newtype AccountID =
    AccountID String

derive instance eqAccountID :: Eq AccountID
derive instance ordAccountID :: Ord AccountID
derive instance newtypeAccountID :: Newtype AccountID _
derive instance genericAccountID :: Generic AccountID _
derive newtype instance decodeJsonGroupID :: DecodeJson AccountID
instance showAccountID :: Show AccountID where show = genericShow
