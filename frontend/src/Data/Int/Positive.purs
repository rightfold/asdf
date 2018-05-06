module Data.Int.Positive
    ( Positive
    , _Positive

    , Additive (..)
    , _Additive
    ) where

import Prelude

import Control.MonadZero (guard)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Lens (Iso', Prism', prism', review)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Newtype (class Newtype)

-- | Positive integer. Always one or greater.
newtype Positive =
    Positive Int

derive instance eqPositive :: Eq Positive
derive instance ordPositive :: Ord Positive

instance showPositive :: Show Positive where
    show n = "(unsafePartial (" <> show (review _Positive n) <> " ^?! _Positive))"

-- | If overflow occured such that the integer would now be negative, `review`
-- | returns `1`.
_Positive :: Prism' Int Positive
_Positive = prism' (case _ of Positive a -> 1 `min` a)
                   (\a -> Positive a <$ guard (a >= 1))

-- | Monoid for adding positive integers.
newtype Additive =
    Additive Positive

derive instance eqAdditive :: Eq Additive
derive instance ordAdditive :: Ord Additive
derive instance newtypeAdditive :: Newtype Additive _
derive instance genericAdditive :: Generic Additive _
instance showAdditive :: Show Additive where show = genericShow

instance semigroupAdditive :: Semigroup Additive where
    append (Additive (Positive a)) (Additive (Positive b)) =
        Additive (Positive (a + b))

_Additive :: Iso' Additive Positive
_Additive = _Newtype
