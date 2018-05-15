module ASDF.LogIn.Algebra
    ( LOGIN
    , LogIn (..)
    , proxy
    , logIn
    ) where

import Prelude

import ASDF.Credentials (EmailAddress, Password)
import ASDF.Token (Token)
import Data.Functor.Variant (FProxy)
import Data.Maybe (Maybe)
import Data.Symbol (SProxy (..))
import Run (Run, lift)

type LOGIN =
    FProxy LogIn

data LogIn a =
    LogIn (Maybe Token -> a) EmailAddress Password

derive instance functorLogin :: Functor LogIn

proxy :: SProxy "logIn"
proxy = SProxy

logIn :: forall r. EmailAddress -> Password -> Run (logIn :: LOGIN | r) (Maybe Token)
logIn = (lift proxy <<< _) <<< LogIn id
