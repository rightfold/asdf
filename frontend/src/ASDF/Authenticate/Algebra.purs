module ASDF.Authenticate.Algebra
    ( AUTHENTICATE
    , Authenticate (..)
    , proxy
    , getToken
    , putToken
    , deleteToken
    ) where

import Prelude

import ASDF.Token (Token)
import Data.Functor.Variant (FProxy)
import Data.Maybe (Maybe)
import Data.Symbol (SProxy (..))
import Run (Run, lift)

type AUTHENTICATE =
    FProxy Authenticate

data Authenticate a
    = GetToken (Maybe Token -> a)
    | PutToken a Token
    | DeleteToken a

derive instance functorAuthenticate :: Functor Authenticate

proxy :: SProxy "authenticate"
proxy = SProxy

getToken :: forall r. Run (authenticate :: AUTHENTICATE | r) (Maybe Token)
getToken = lift proxy $ GetToken id

putToken :: forall r. Token -> Run (authenticate :: AUTHENTICATE | r) Unit
putToken = lift proxy <<< PutToken unit

deleteToken :: forall r. Run (authenticate :: AUTHENTICATE | r) Unit
deleteToken = lift proxy $ DeleteToken unit
