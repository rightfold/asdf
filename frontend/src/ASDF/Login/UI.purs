module ASDF.Login.UI
    ( Query
    , Input
    , Output
    , Algebra
    , ui
    ) where

import Prelude

import ASDF.Authenticate.Algebra (AUTHENTICATE, getToken, putToken)
import ASDF.Credentials (EmailAddress (..), Password (..))
import ASDF.Login.Algebra (LOGIN, login)
import ASDF.Token (Token)
import Control.Monad.Trans.Class (lift)
import Control.MonadZero.Extra (guarding)
import Data.Foldable (traverse_)
import Data.Lens (Lens', (^.), (%=), (.=), to, use)
import Data.Lens.Record (prop)
import Data.Maybe (Maybe (..), isNothing)
import Data.Symbol (SProxy (..))
import Halogen.Component (Component, ComponentDSL, ComponentHTML, lifecycleComponent)
import Halogen.HTML (HTML)
import Halogen.Query (raise)
import Run (Run)

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
type Algebra r = (authenticate :: AUTHENTICATE, login :: LOGIN | r)

ui :: forall r. Component HTML Query Input Output (Run (Algebra r))
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

eval :: forall r. Query ~> ComponentDSL State Query Output (Run (Algebra r))

eval (InitializeQuery next) = do
    token <- getToken                                      # lift
    traverse_ (const $ raise unit) token
    pure next

eval (InputQuery next f) =
    next <$ (id %= f)

eval (SubmitQuery next) = do
    emailAddress <- use $ stateEmailAddress <<< to EmailAddress
    password <- use $ statePassword <<< to Password
    token <- login emailAddress password                   # lift

    stateError .= isNothing token
    traverse_ success token

    pure next

    where
        success :: Token -> ComponentDSL State Query Output (Run (Algebra r)) Unit
        success t = do
            putToken t                                     # lift
            raise unit

receiver :: forall a b. a -> Maybe b
receiver _ = Nothing

initializer :: Maybe (Query Unit)
initializer = Just $ InitializeQuery unit

finalizer :: forall a. Maybe a
finalizer = Nothing
