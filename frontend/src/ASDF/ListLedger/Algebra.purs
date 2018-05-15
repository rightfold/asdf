module ASDF.ListLedger.Algebra
    ( LISTLEDGER
    , ListLedger (..)
    , proxy
    , listLedger
    ) where

import Prelude

import ASDF.Group (GroupID)
import ASDF.Ledger (Transaction)
import Data.Functor.Variant (FProxy)
import Data.Symbol (SProxy (..))
import Run (Run, lift)

type LISTLEDGER =
    FProxy ListLedger

data ListLedger a =
    ListLedger (Array Transaction -> a) GroupID

derive instance functorListLedger :: Functor ListLedger

proxy :: SProxy "listLedger"
proxy = SProxy

listLedger :: forall r. GroupID -> Run (listLedger :: LISTLEDGER | r) (Array Transaction)
listLedger = lift proxy <<< ListLedger id
