module Data.UUID
    ( UUID

    , nil
    , fromQuadruple

    , toString
    , fromString
    , toBytes
    , fromBytes
    ) where

import Prelude

import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Either (note)
import Data.Foldable (foldMap)
import Data.Int.Bits ((.&.), zshr)
import Data.Maybe (Maybe (..))
import Partial (crashWith)

import Data.Int as Int

data UUID = UUID Int Int Int Int

derive instance eqUUID :: Eq UUID
derive instance ordUUID :: Ord UUID

instance showUUID :: Show UUID where
    show (UUID a b c d) =
        "(unsafePartial fromQuadruple " <>
        show a <> " " <> show b <> " " <>
        show c <> " " <> show d <> ")"

instance decodeJson :: DecodeJson UUID where
    decodeJson = note "Invalid UUID" <<< fromString <=< decodeJson

instance encodeJson :: EncodeJson UUID where
    encodeJson = encodeJson <<< toString

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

toString :: UUID -> String
toString = foldMap int <<< toBytes
    where int n | n <= 0xF  = " " <> int' n
                | otherwise = int' n
          int' = Int.toStringAs Int.hexadecimal

fromString :: String -> Maybe UUID
fromString _ = Just nil -- TODO: Implement properly.

toBytes :: UUID -> Array Int
toBytes (UUID a b c d) =
    let
        toBE :: Int -> Array Int
        toBE x =
            (_ .&. 0xFF) <$>
            [ x `zshr` 24
            , x `zshr` 16
            , x `zshr`  8
            , x `zshr`  0 ]
    in
        toBE a <> toBE b <>
        toBE c <> toBE d

fromBytes :: Array Int -> Maybe UUID
fromBytes _ = Just nil -- TODO: Implement properly.
