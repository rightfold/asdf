module ASDF.Group
    ( GroupID (..)
    ) where

import Prelude

import Data.Argonaut.Encode (class EncodeJson)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)

newtype GroupID = GroupID String

derive instance eqGroupID :: Eq GroupID
derive instance ordGroupID :: Ord GroupID
derive instance newtypeGroupID :: Newtype GroupID _
derive instance genericGroupID :: Generic GroupID _
derive newtype instance encodeJsonGroupID :: EncodeJson GroupID
instance showGroupID :: Show GroupID where show = genericShow
