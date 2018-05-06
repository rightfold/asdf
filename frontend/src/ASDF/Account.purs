module ASDF.Account
    ( AccountID
    ) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)
import Data.UUID (UUID)

newtype AccountID =
    AccountID UUID

derive instance eqAccountID :: Eq AccountID
derive instance ordAccountID :: Ord AccountID
derive instance newtypeAccountID :: Newtype AccountID _
derive instance genericAccountID :: Generic AccountID _
instance showAccountID :: Show AccountID where show = genericShow
