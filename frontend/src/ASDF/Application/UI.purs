module ASDF.Application.UI
    ( Query
    , Input
    , Output
    , Algebra
    , ui
    ) where

import Prelude

import Data.Const (Const)
import Data.Either.Nested (Either2)
import Data.Functor.Coproduct.Nested (type (<\/>))
import Data.Lens ((.=))
import Data.Maybe (Maybe (..))
import Halogen.Component (Component, ParentDSL, ParentHTML, parentComponent)
import Halogen.Component.ChildPath (cp1, cp2)
import Halogen.HTML (HTML)
import Run (Run)

import ASDF.Dashboard.UI as Dashboard.UI
import ASDF.Login.UI as Login.UI
import Halogen.HTML as HH

data State
    = Login
    | Dashboard
    | Settings

data Query a
    = LoggedInQuery a
type ChildQuery = Login.UI.Query <\/> Dashboard.UI.Query <\/> Const Void
type Input = Unit
type Output = Void
type Slot = Either2 Unit Unit
type Algebra r = Login.UI.Algebra (Dashboard.UI.Algebra r)

ui :: forall r. Component HTML Query Input Output (Run (Algebra r))
ui = parentComponent {initialState, render, eval, receiver}

initialState :: Input -> State
initialState _ = Login

render :: forall r. State -> ParentHTML Query ChildQuery Slot (Run (Algebra r))
render Login     = HH.slot' cp1 unit Login.UI.ui unit (Just <<< LoggedInQuery)
render Dashboard = HH.slot' cp2 unit Dashboard.UI.ui unit absurd
render Settings  = HH.text "SETTINGS"

eval :: forall r. Query ~> ParentDSL State Query ChildQuery Slot Output (Run (Algebra r))
eval (LoggedInQuery next) = next <$ (id .= Dashboard)

receiver :: forall a b. a -> Maybe b
receiver _ = Nothing
