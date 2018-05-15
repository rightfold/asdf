module ASDF.Login.Algebra
    ( LOGIN
    , Login (..)
    , proxy
    , login
    ) where

import Prelude

import ASDF.Credentials (EmailAddress, Password)
import ASDF.Token (Token)
import Data.Functor.Variant (FProxy)
import Data.Maybe (Maybe)
import Data.Symbol (SProxy (..))
import Run (Run, lift)

type LOGIN =
    FProxy Login

data Login a =
    Login (Maybe Token -> a) EmailAddress Password

derive instance functorLogin :: Functor Login

proxy :: SProxy "login"
proxy = SProxy

login :: forall r. EmailAddress -> Password -> Run (login :: LOGIN | r) (Maybe Token)
login = (lift proxy <<< _) <<< Login id
