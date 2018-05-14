module ASDF.ListLedger.AJAX
    ( interpret
    ) where

import Prelude

import ASDF.Account (AccountID (..))
import ASDF.Ledger (Transaction (..), TransactionType (..))
import ASDF.ListLedger.Algebra (ListLedger (..))
import Control.Monad.Aff.Class (class MonadAff)
import Data.Int.Positive (Positive, _Positive)
import Data.Lens.Fold.Partial ((^?!))
import Data.UUID (nil)
import Network.HTTP.Affjax (AJAX)
import Partial.Unsafe (unsafePartial)

baseURL :: String
baseURL = "http://localhost:8080"

interpret
    :: forall eff m
     . MonadAff (ajax :: AJAX | eff) m
    => ListLedger ~> m
interpret (ListLedger next group) =
    pure <<< next $
        [ Transaction Debt top "Chips" (AccountID nil) (AccountID nil) (amount 200)
        , Transaction Debt top "Taart" (AccountID nil) (AccountID nil) (amount 800)
        , Transaction Debt top "Donut" (AccountID nil) (AccountID nil) (amount 200)
        , Transaction Debt top "Rotje" (AccountID nil) (AccountID nil) (amount 200) ]
    where
        amount :: Int -> Positive
        amount n = unsafePartial $ n ^?! _Positive
