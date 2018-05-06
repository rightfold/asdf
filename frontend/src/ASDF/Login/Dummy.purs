module ASDF.Login.Dummy
    ( interpret
    , dummyEmailAddress
    , dummyPassword
    , dummyToken
    ) where

import Prelude

import ASDF.Authenticate (Token (..))
import ASDF.Login (EmailAddress (..), Login (..), Password (..))
import Control.Monad.Eff.Class (class MonadEff, liftEff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.MonadZero (guard)
import Data.Tuple.Nested ((/\))

interpret
    :: forall eff m
     . MonadEff (console :: CONSOLE | eff) m
    => Applicative m
    => Login ~> m
interpret (Login next emailAddress password) =
  liftEff $ do
    logShow (emailAddress /\ password)
    pure <<< next $ do
        guard $ emailAddress == dummyEmailAddress
        guard $ password == dummyPassword
        pure dummyToken

dummyEmailAddress :: EmailAddress
dummyEmailAddress = EmailAddress "asdf@example.com"

dummyPassword :: Password
dummyPassword = Password "asdf"

dummyToken :: Token
dummyToken = Token "DUMMY"
