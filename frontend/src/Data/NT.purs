module Data.NT
    ( type (~>>), NT (..)
    , ($~>>), applyNT
    ) where

import Prelude

infixr 4 type NT as ~>>
infixr 0 applyNT as $~>>

newtype NT f g = NT (f ~> g)

applyNT :: forall f g. NT f g -> f ~> g
applyNT (NT f) = f
