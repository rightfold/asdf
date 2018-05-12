module Main
    ( main
    ) where

import Prelude

import Control.Monad.Aff.Class (class MonadAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (class MonadEff, liftEff)
import Control.Monad.Free (foldFree)
import Control.Monad.Rec.Class (class MonadRec)
import Data.Functor.Coproduct (coproduct)
import Data.Newtype (unwrap)
import Data.NT (NT (..), type (~>>), ($~>>))
import DOM (DOM)
import Halogen.Aff (HalogenEffects, awaitBody, runHalogenAff)
import Halogen.Component (hoist)
import Halogen.VDom.Driver (runUI)
import Network.HTTP.Affjax (AJAX)

import ASDF.Authenticate.WebStorage as Authenticate.WebStorage
import ASDF.Login.AJAX as Login.AJAX
import ASDF.Login.UI as Login.UI
import DOM.HTML (window) as DOM
import DOM.HTML.Window (localStorage) as DOM

main :: forall eff. Eff (HalogenEffects (ajax :: AJAX | eff)) Unit
main = runHalogenAff $ do
    interpret <- interpreter
    body <- awaitBody
    runUI (hoist (interpret $~>> _) Login.UI.ui) unit body

interpreter
    :: forall eff m eff' m'
     . MonadEff (dom :: DOM | eff) m
    => MonadAff (ajax :: AJAX, dom :: DOM | eff') m'
    => MonadRec m'
    => m (Login.UI.Monad ~>> m')
interpreter = liftEff $ do
    window <- DOM.window
    storage <- DOM.localStorage window
    pure $ NT (foldFree (coproduct (Authenticate.WebStorage.interpret storage)
                        (coproduct Login.AJAX.interpret
                        (absurd <<< unwrap))))
