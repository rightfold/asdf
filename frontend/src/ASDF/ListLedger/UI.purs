module ASDF.ListLedger.UI
    ( Query
    , Input
    , Output
    , Algebra
    , ui
    ) where

import Prelude

import ASDF.Group (GroupID (..))
import ASDF.Ledger (Transaction)
import ASDF.ListLedger.Algebra (LISTLEDGER, listLedger)
import Control.Monad.Trans.Class (lift)
import Data.Lens (Lens', (^.), (.=))
import Data.Lens.Record (prop)
import Data.Maybe (Maybe (..))
import Data.Symbol (SProxy (..))
import Halogen.Component (Component, ComponentDSL, ComponentHTML, lifecycleComponent)
import Halogen.HTML (HTML)
import Run (Run)

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
type Algebra r = (listLedger :: LISTLEDGER | r)

ui :: forall r. Component HTML Query Input Output (Run (Algebra r))
ui = lifecycleComponent {initialState, render, eval, receiver, initializer, finalizer}

initialState :: forall a. a -> State
initialState _ = {error: false, ledgerSlice: []}

render :: State -> ComponentHTML Query
render s = HH.text <<< show $ s ^. stateLedgerSlice

eval :: forall r. Query ~> ComponentDSL State Query Output (Run (Algebra r))

eval (InitializeQuery next) = do
  ledgerSlice <- listLedger (GroupID "00000000000000000000000000000000") # lift
  stateError .= false
  stateLedgerSlice .= ledgerSlice
  pure next

receiver :: forall a b. a -> Maybe b
receiver _ = Nothing

initializer :: Maybe (Query Unit)
initializer = Just $ InitializeQuery unit

finalizer :: forall a. Maybe a
finalizer = Nothing
