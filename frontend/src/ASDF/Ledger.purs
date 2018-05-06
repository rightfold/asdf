module ASDF.Ledger
    ( LedgerID (..)

    , Transaction (..)
    , transactionType
    , transactionTimestamp
    , transactionComment
    , transactionDebitor
    , transactionCreditor
    , transactionAmount

    , TransactionType (..)
    , _Debt
    , _Payment
    ) where

import Prelude

import ASDF.Account (AccountID)
import Control.MonadZero (guard)
import Data.DateTime.Instant (Instant)
import Data.Int.Positive (Positive)
import Data.Lens (Lens', Prism', lens, prism')
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)
import Data.UUID (UUID)

newtype LedgerID =
    LedgerID UUID

derive instance eqLedgerID :: Eq LedgerID
derive instance ordLedgerID :: Ord LedgerID
derive instance newtypeLedgerID :: Newtype LedgerID _
derive instance genericLedgerID :: Generic LedgerID _
instance showLedgerID :: Show LedgerID where show = genericShow

data Transaction =
    Transaction
        TransactionType
        Instant
        String
        AccountID
        AccountID
        Positive

derive instance genericTransaction :: Generic Transaction _
instance showTransaction :: Show Transaction where show = genericShow

transactionType :: Lens' Transaction TransactionType
transactionType = lens get set
    where get (Transaction a _ _ _ _ _) = a
          set (Transaction _ b c d e f) a = Transaction a b c d e f

transactionTimestamp :: Lens' Transaction Instant
transactionTimestamp = lens get set
    where get (Transaction _ b _ _ _ _) = b
          set (Transaction a _ c d e f) b = Transaction a b c d e f

transactionComment :: Lens' Transaction String
transactionComment = lens get set
    where get (Transaction _ _ c _ _ _) = c
          set (Transaction a b _ d e f) c = Transaction a b c d e f

transactionDebitor :: Lens' Transaction AccountID
transactionDebitor = lens get set
    where get (Transaction _ _ _ d _ _) = d
          set (Transaction a b c _ e f) d = Transaction a b c d e f

transactionCreditor :: Lens' Transaction AccountID
transactionCreditor = lens get set
    where get (Transaction _ _ _ _ e _) = e
          set (Transaction a b c d _ f) e = Transaction a b c d e f

transactionAmount :: Lens' Transaction Positive
transactionAmount = lens get set
    where get (Transaction _ _ _ _ _ f) = f
          set (Transaction a b c d e _) f = Transaction a b c d e f

data TransactionType
    = Debt | Payment

derive instance eqTransactionType :: Eq TransactionType
derive instance ordTransactionType :: Ord TransactionType
derive instance genericTransactionType :: Generic TransactionType _
instance showTransactionType :: Show TransactionType where show = genericShow

_Debt :: Prism' TransactionType Unit
_Debt = prism' (const Debt) (void <<< guard <<< eq Debt)

_Payment :: Prism' TransactionType Unit
_Payment = prism' (const Payment) (void <<< guard <<< eq Payment)
