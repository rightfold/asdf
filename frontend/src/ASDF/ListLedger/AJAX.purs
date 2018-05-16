module ASDF.ListLedger.AJAX
    ( interpret
    ) where

import Prelude

import ASDF.Group (GroupID)
import ASDF.Ledger (Transaction)
import ASDF.ListLedger.Algebra (ListLedger (..))
import Control.Monad.Aff.Class (class MonadAff, liftAff)
import Control.Monad.Eff.Exception (error)
import Control.Monad.Error.Class (throwError)
import Data.Argonaut.Core (jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, (.?), decodeJson)
import Data.Argonaut.Encode (class EncodeJson, (~>), (:=), encodeJson)
import Data.Argonaut.Extra (decodeJsonM)
import Network.HTTP.Affjax (AJAX)
import Network.HTTP.StatusCode (StatusCode (..))

import Network.HTTP.Affjax as Affjax

baseURL :: String
baseURL = "http://localhost:8080"

interpret
    :: forall eff m
     . MonadAff (ajax :: AJAX | eff) m
    => ListLedger ~> m
interpret (ListLedger next group) = liftAff $ do
    let request = encodeJson $ Request group
    {status, response} <- Affjax.post (baseURL <> "/list-ledger") request
    case status of
        StatusCode 200 -> do
            Response transactions <- decodeJsonM response
            pure <<< next $ transactions
        StatusCode c ->
            liftAff <<< throwError <<< error $
                "Unexpected status code " <> show c

newtype Request = Request GroupID
newtype Response = Response (Array Transaction)

instance encodeJsonRequest :: EncodeJson Request where
    encodeJson (Request group) = "group" := group ~> jsonEmptyObject

instance decodeJsonResponse :: DecodeJson Response where
    decodeJson json = do
        output <- decodeJson json >>= (_ .? "transactions")
        pure <<< Response $ output
