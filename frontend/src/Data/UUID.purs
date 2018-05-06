module Data.UUID
    ( UUID

    , nil
    , fromQuadruple
    ) where

import Prelude

import Data.Int.Bits ((.&.), zshr)
import Partial (crashWith)

data UUID = UUID Int Int Int Int

derive instance eqUUID :: Eq UUID
derive instance ordUUID :: Ord UUID

instance showUUID :: Show UUID where
    show (UUID a b c d) =
        "(unsafePartial fromQuadruple " <>
        show a <> " " <> show b <> " " <>
        show c <> " " <> show d <> ")"

nil :: UUID
nil = UUID 0 0 0 0

fromQuadruple :: Partial => Int -> Int -> Int -> Int -> UUID
fromQuadruple 0 0 0 0 = nil
fromQuadruple a b c d
    | not (between 0x1 0x5) (zshr b 12 .&. 0xF) =
        crashWith "Data.UUID.fromQuadruple: Invalid version"
    | not (between 0x8 0xB) (zshr c 28 .&. 0xF) =
        crashWith "Data.UUID.fromQuadruple: Invalid variant"
    | otherwise = UUID a b c d
