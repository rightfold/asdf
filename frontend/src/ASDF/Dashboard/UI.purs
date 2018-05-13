module ASDF.Dashboard.UI
    ( Query
    , Input
    , Output
    , Monad
    , ui
    ) where

import Prelude

import Data.Maybe (Maybe (..))
import Halogen.Component (Component, ComponentDSL, ComponentHTML, component)
import Halogen.HTML (HTML)

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

type State = Unit
data Query a =
    Query Void
type Input = Unit
type Output = Void
type Monad (a :: Type -> Type) = a

ui :: forall a. Component HTML Query Input Output (Monad a)
ui = component {initialState, render, eval, receiver}

initialState :: forall a. a -> State
initialState _ = unit

render :: State -> ComponentHTML Query
render _ =
    HH.div []
        [ HH.select []
            [ HH.option [] [HH.text "Debt"]
            , HH.option [] [HH.text "Payment"] ]
        , HH.input [ HP.type_ HP.InputNumber
                   , HP.step (HP.Step 0.01) ]
        , HH.select [] []
        , HH.select [] []
        , HH.button [] [HH.text "Append"] ]

eval :: forall a. Query ~> ComponentDSL State Query Output (Monad a)
eval (Query a) = absurd a

receiver :: forall a b. a -> Maybe b
receiver _ = Nothing
