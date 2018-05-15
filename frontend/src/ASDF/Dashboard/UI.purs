module ASDF.Dashboard.UI
    ( Query
    , Input
    , Output
    , Algebra
    , ui
    ) where

import Prelude

import Data.Maybe (Maybe (..))
import Halogen.Component (Component, ParentDSL, ParentHTML, parentComponent)
import Halogen.HTML (HTML)
import Run (Run)

import ASDF.ListLedger.UI as ListLedger.UI
import Halogen.HTML as HH
import Halogen.HTML.Extra as HU
import Halogen.HTML.Properties as HP

type State = Unit
data Query a =
    Query Void
type ChildQuery = ListLedger.UI.Query
type Input = Unit
type Output = Void
type Slot = Unit
type Algebra r = ListLedger.UI.Algebra r

ui :: forall r. Component HTML Query Input Output (Run (Algebra r))
ui = parentComponent {initialState, render, eval, receiver}

initialState :: forall a. a -> State
initialState _ = unit

render :: forall r. State -> ParentHTML Query ChildQuery Slot (Run (Algebra r))
render _ =
    HH.div [HU.classes "asdf--dashboard"]
        [ HH.div [HU.classes "-transaction-form"]
            [ HH.select []
                [ HH.option [] [HH.text "Debt"]
                , HH.option [] [HH.text "Payment"] ]
            , HH.input [ HP.type_ HP.InputNumber
                    , HP.step (HP.Step 0.01) ]
            , HH.select [] []
            , HH.select [] []
            , HH.button [] [HH.text "Append"] ]
        , HH.slot unit ListLedger.UI.ui unit absurd ]

eval :: forall r. Query ~> ParentDSL State Query ChildQuery Slot Output (Run (Algebra r))
eval (Query a) = absurd a

receiver :: forall a b. a -> Maybe b
receiver _ = Nothing
