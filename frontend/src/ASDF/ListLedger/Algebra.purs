module ASDF.ListLedger.Algebra
    ( ListLedger (..)
    , listLedger
    ) where

import Prelude

import ASDF.Group (GroupID)
import ASDF.Ledger (Transaction)
import Control.Monad.Free (Free, liftF)

data ListLedger a =
    ListLedger (Array Transaction -> a) GroupID

listLedger :: GroupID -> Free ListLedger (Array Transaction)
listLedger = liftF <<< ListLedger id
