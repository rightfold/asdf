module Main
    ( main
    ) where

import Prelude

import ASDF.Authenticate.Algebra (Authenticate)
import ASDF.ListLedger.Algebra (ListLedger)
import ASDF.Login.Algebra (Login)
import Control.Monad.Aff.Class (class MonadAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (class MonadEff, liftEff)
import Control.Monad.Free (foldFree)
import Control.Monad.Rec.Class (class MonadRec)
import Data.Functor.Coproduct (coproduct)
import Data.NT (NT (..), type (~>>), ($~>>))
import DOM (DOM)
import Halogen.Aff (HalogenEffects, awaitBody, runHalogenAff)
import Halogen.Component (hoist)
import Halogen.VDom.Driver (runUI)
import Network.HTTP.Affjax (AJAX)

import ASDF.Application.UI as Application.UI
import ASDF.Authenticate.WebStorage as Authenticate.WebStorage
import ASDF.Dashboard.UI as Dashboard.UI
import ASDF.ListLedger.AJAX as ListLedger.AJAX
import ASDF.ListLedger.UI as ListLedger.UI
import ASDF.Login.AJAX as Login.AJAX
import ASDF.Login.UI as Login.UI
import DOM.HTML (window) as DOM
import DOM.HTML.Window (localStorage) as DOM

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
    => m (Application.UI.Monad ~>> m')
interpreter = liftEff $ do
    window <- DOM.window
    storage <- DOM.localStorage window

    let interpretAuthenticate :: Authenticate ~> m'
        interpretAuthenticate = Authenticate.WebStorage.interpret storage

    let interpretListLedger :: ListLedger ~> m'
        interpretListLedger = ListLedger.AJAX.interpret

    let interpretLogin :: Login ~> m'
        interpretLogin = Login.AJAX.interpret

    let interpretListLedgerUIMonad :: ListLedger.UI.Monad ~> m'
        interpretListLedgerUIMonad =
            foldFree interpretListLedger

    let interpretLoginUIMonad :: Login.UI.Monad ~> m'
        interpretLoginUIMonad =
            foldFree (
                interpretAuthenticate `coproduct`
                interpretLogin
            )

    let interpretDashboardUIMonad :: Dashboard.UI.Monad ~> m'
        interpretDashboardUIMonad =
            interpretListLedgerUIMonad

    let interpretApplicationUIMonad :: Application.UI.Monad ~> m'
        interpretApplicationUIMonad =
            foldFree (
                interpretLoginUIMonad `coproduct`
                interpretDashboardUIMonad
            )

    pure $ NT interpretApplicationUIMonad
