module ASDF.ListLedger.UI
    ( Query
    , Input
    , Output
    , Monad
    , ui
    ) where

import Prelude

import ASDF.Group (GroupID (..))
import ASDF.Ledger (Transaction)
import ASDF.ListLedger.Algebra (ListLedger, listLedger)
import Control.Monad.Free (Free)
import Control.Monad.Trans.Class (lift)
import Data.Lens (Lens', (^.), (.=))
import Data.Lens.Record (prop)
import Data.Maybe (Maybe (..))
import Data.Symbol (SProxy (..))
import Data.UUID (nil)
import Halogen.Component (Component, ComponentDSL, ComponentHTML, lifecycleComponent)
import Halogen.HTML (HTML)

import Halogen.HTML as HH

type State =
    { error       :: Boolean
    , ledgerSlice :: Array Transaction }

stateError :: Lens' State Boolean
stateError = prop (SProxy :: SProxy "error")

stateLedgerSlice :: Lens' State (Array Transaction)
stateLedgerSlice = prop (SProxy :: SProxy "ledgerSlice")

data Query a
    = InitializeQuery a
type Input = Unit
type Output = Void
type Monad = Free ListLedger

ui :: Component HTML Query Input Output Monad
ui = lifecycleComponent {initialState, render, eval, receiver, initializer, finalizer}

initialState :: forall a. a -> State
initialState _ = {error: false, ledgerSlice: []}

render :: State -> ComponentHTML Query
render s = HH.text <<< show $ s ^. stateLedgerSlice

eval :: Query ~> ComponentDSL State Query Output Monad

eval (InitializeQuery next) = do
  ledgerSlice <- listLedger (GroupID nil)                  # lift
  stateError .= false
  stateLedgerSlice .= ledgerSlice
  pure next

receiver :: forall a b. a -> Maybe b
receiver _ = Nothing

initializer :: Maybe (Query Unit)
initializer = Just $ InitializeQuery unit

finalizer :: forall a. Maybe a
finalizer = Nothing
