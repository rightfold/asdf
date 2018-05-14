module ASDF.Group
    ( GroupID (..)
    ) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)
import Data.UUID (UUID)

newtype GroupID = GroupID UUID

derive instance eqGroupID :: Eq GroupID
derive instance ordGroupID :: Ord GroupID
derive instance newtypeGroupID :: Newtype GroupID _
derive instance genericGroupID :: Generic GroupID _
instance showGroupID :: Show GroupID where show = genericShow
