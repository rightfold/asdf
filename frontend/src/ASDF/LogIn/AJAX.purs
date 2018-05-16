module ASDF.LogIn.AJAX
    ( interpret
    ) where

import Prelude

import ASDF.Credentials (EmailAddress, Password)
import ASDF.LogIn.Algebra (LogIn (..))
import ASDF.Token (Token (..))
import Control.Monad.Aff.Class (class MonadAff, liftAff)
import Control.Monad.Eff.Exception (error)
import Control.Monad.Error.Class (throwError)
import Data.Argonaut.Core (jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, (.?), decodeJson)
import Data.Argonaut.Encode (class EncodeJson, (~>), (:=), encodeJson)
import Data.Argonaut.Extra (decodeJsonM)
import Data.Maybe (Maybe (..))
import Data.Newtype (unwrap)
import Network.HTTP.Affjax (AJAX)
import Network.HTTP.StatusCode (StatusCode (..))

import Network.HTTP.Affjax as Affjax

baseURL :: String
baseURL = "http://localhost:8080"

interpret
    :: forall eff m
     . MonadAff (ajax :: AJAX | eff) m
    => LogIn ~> m
interpret (LogIn next emailAddress password) = liftAff $ do
    let request = encodeJson $ Request emailAddress password
    {status, response} <- Affjax.post (baseURL <> "/log-in") request
    case status of
        StatusCode 200 -> do
            Response token <- decodeJsonM response
            pure <<< next $ Just token
        StatusCode 401 ->
            pure <<< next $ Nothing
        StatusCode c ->
            liftAff <<< throwError <<< error $
                "Unexpected status code " <> show c

data Request = Request EmailAddress Password
newtype Response = Response Token

instance encodeJsonRequest :: EncodeJson Request where
    encodeJson (Request emailAddress password) =
        "email_address" := unwrap emailAddress ~>
        "password"      := unwrap password     ~>
        jsonEmptyObject

instance decodeJsonResponse :: DecodeJson Response where
    decodeJson json = do
        output <- decodeJson json >>= (_ .? "token")
        pure <<< Response $ Token output
