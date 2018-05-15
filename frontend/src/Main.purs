module Main
    ( main
    ) where

import Prelude

import Control.Monad.Aff.Class (class MonadAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (class MonadEff, liftEff)
import Control.Monad.Rec.Class (class MonadRec)
import Data.Functor.Variant (VariantF, match)
import Data.NT (NT (..), type (~>>), ($~>>))
import DOM (DOM)
import Halogen.Aff (HalogenEffects, awaitBody, runHalogenAff)
import Halogen.Component (hoist)
import Halogen.VDom.Driver (runUI)
import Network.HTTP.Affjax (AJAX)
import Run (Run)

import ASDF.Application.UI as Application.UI
import ASDF.Authenticate.WebStorage as Authenticate.WebStorage
import ASDF.ListLedger.AJAX as ListLedger.AJAX
import ASDF.LogIn.AJAX as LogIn.AJAX
import DOM.HTML (window) as DOM
import DOM.HTML.Window (localStorage) as DOM
import Run as Run

main :: forall eff. Eff (HalogenEffects (ajax :: AJAX | eff)) Unit
main = runHalogenAff $ do
    interpret <- interpreter
    body <- awaitBody
    runUI (hoist (interpret $~>> _) Application.UI.ui) unit body

interpreter
    :: forall eff m eff' m'
     . MonadEff (dom :: DOM | eff) m
    => MonadAff (ajax :: AJAX, dom :: DOM | eff') m'
    => MonadRec m'
    => m (Run (Application.UI.Algebra ()) ~>> m')
interpreter = liftEff $ do
    window <- DOM.window
    storage <- DOM.localStorage window

    let interpret :: VariantF (Application.UI.Algebra ()) ~> m'
        interpret = match
            { authenticate: \a -> Authenticate.WebStorage.interpret storage a
            , listLedger:   \a -> ListLedger.AJAX.interpret a
            , logIn:        \a -> LogIn.AJAX.interpret a }

    pure $ NT (Run.interpret interpret)
