module ASDF.Dashboard.UI
    ( Query
    , Input
    , Output
    , Monad
    , ui
    ) where

import Prelude

import Data.Lens ((.=))
import Data.Maybe (Maybe (..))
import Halogen.Component (Component, ParentDSL, ParentHTML, parentComponent)
import Halogen.HTML (HTML)

import ASDF.Login.UI as Login.UI
import Halogen.HTML as HH

data State
    = NotLoggedIn
    | LoggedIn

data Query a
    = LoggedInQuery a
type ChildQuery = Login.UI.Query
type Input = Unit
type Output = Void
data Slot = LoginSlot
type Monad = Login.UI.Monad

derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot

ui :: Component HTML Query Input Output Monad
ui = parentComponent {initialState, render, eval, receiver}

initialState :: Input -> State
initialState _ = NotLoggedIn

render :: State -> ParentHTML Query ChildQuery Slot Monad
render NotLoggedIn = HH.slot LoginSlot Login.UI.ui unit (Just <<< LoggedInQuery)
render LoggedIn = HH.text "Logged in!"

eval :: Query ~> ParentDSL State Query ChildQuery Slot Output Monad
eval (LoggedInQuery next) = next <$ (id .= LoggedIn)

receiver :: forall a b. a -> Maybe b
receiver _ = Nothing
