module ASDF.Application.UI
    ( Query
    , Input
    , Output
    , Monad
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
type Monad = Login.UI.Monad

ui :: Component HTML Query Input Output Monad
ui = parentComponent {initialState, render, eval, receiver}

initialState :: Input -> State
initialState _ = Login

render :: State -> ParentHTML Query ChildQuery Slot Monad
render Login     = HH.slot' cp1 unit Login.UI.ui unit (Just <<< LoggedInQuery)
render Dashboard = HH.slot' cp2 unit Dashboard.UI.ui unit absurd
render Settings  = HH.text "SETTINGS"

eval :: Query ~> ParentDSL State Query ChildQuery Slot Output Monad
eval (LoggedInQuery next) = next <$ (id .= Dashboard)

receiver :: forall a b. a -> Maybe b
receiver _ = Nothing
