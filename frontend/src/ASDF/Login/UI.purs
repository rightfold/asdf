module ASDF.Login.UI
    ( Query
    , Input
    , Output
    , Monad
    , ui
    ) where

import Prelude

import ASDF.Authenticate (Authenticate, Token, getToken, putToken)
import ASDF.Login (EmailAddress (..), Login, Password (..), login)
import Control.Monad.Free (Free, hoistFree)
import Control.Monad.Trans.Class (lift)
import Control.MonadZero.Extra (guarding)
import Data.Const (Const)
import Data.Foldable (traverse_)
import Data.Functor.Coproduct (left, right)
import Data.Functor.Coproduct.Nested (type (<\/>))
import Data.Lens (Lens', (^.), (%=), (.=), to, use)
import Data.Lens.Record (prop)
import Data.Maybe (Maybe (..), isNothing)
import Data.Symbol (SProxy (..))
import Halogen.Component (Component, ComponentDSL, ComponentHTML, lifecycleComponent)
import Halogen.HTML (HTML)
import Halogen.Query (raise)

import ASDF.I18N as I18N
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Extra as HU
import Halogen.HTML.Properties as HP

type State =
    { error        :: Boolean
    , emailAddress :: String
    , password     :: String }

stateError :: Lens' State Boolean
stateError = prop (SProxy :: SProxy "error")

stateEmailAddress :: Lens' State String
stateEmailAddress = prop (SProxy :: SProxy "emailAddress")

statePassword :: Lens' State String
statePassword = prop (SProxy :: SProxy "password")

data Query a
    = InitializeQuery a
    | InputQuery a (State -> State)
    | SubmitQuery a
type Input = Unit
type Output = Unit
type Monad = Free (Authenticate <\/> Login <\/> Const Void)

liftAuthenticate :: Free Authenticate ~> Monad
liftAuthenticate = hoistFree left

liftLogin :: Free Login ~> Monad
liftLogin = hoistFree (right <<< left)

ui :: Component HTML Query Input Output Monad
ui = lifecycleComponent {initialState, render, eval, receiver, initializer, finalizer}

initialState :: forall a. a -> State
initialState _ = {error: false, emailAddress: "", password: ""}

render :: State -> ComponentHTML Query
render s =
    HH.div [] $ join
        [ guarding (s ^. stateError)
          [HH.text I18N.m_login_invalidCredentials]
        , [ HU.lensedInput HP.InputEmail stateEmailAddress (InputQuery unit) s
          , HU.lensedInput HP.InputPassword statePassword (InputQuery unit) s
          , HH.button
              [HE.onClick (const (Just (SubmitQuery unit)))]
              [HH.text I18N.m_login_logIn] ] ]

eval :: Query ~> ComponentDSL State Query Output Monad

eval (InitializeQuery next) = do
    token <- getToken                                      # liftAuthenticate >>> lift
    traverse_ (const $ raise unit) token
    pure next

eval (InputQuery next f) =
    next <$ (id %= f)

eval (SubmitQuery next) = do
    emailAddress <- use $ stateEmailAddress <<< to EmailAddress
    password <- use $ statePassword <<< to Password
    token <- login emailAddress password                   # liftLogin >>> lift

    stateError .= isNothing token
    traverse_ success token

    pure next

    where
        success :: Token -> ComponentDSL State Query Output Monad Unit
        success t = do
            putToken t                                     # liftAuthenticate >>> lift
            raise unit

receiver :: forall a b. a -> Maybe b
receiver _ = Nothing

initializer :: Maybe (Query Unit)
initializer = Just $ InitializeQuery unit

finalizer :: forall a. Maybe a
finalizer = Nothing
