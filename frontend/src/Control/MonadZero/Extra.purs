module Control.MonadZero.Extra
    ( guarding
    ) where

import Prelude

import Control.MonadZero (class MonadZero, guard)

guarding :: forall m a. MonadZero m => Boolean -> m a -> m a
guarding = (*>) <<< guard
