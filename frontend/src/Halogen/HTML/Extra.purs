module Halogen.HTML.Extra
    ( classes
    , lensedInput
    ) where

import Prelude

import Data.Lens (Lens', (^.), (.~))
import Data.Maybe (Maybe (..))
import Data.Newtype (wrap)
import Halogen.HTML (HTML)

import Data.String as String
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

classes :: forall a b. String -> HP.IProp ("class" :: String | a) b
classes = HP.classes <<< map wrap <<< String.split (wrap " ")

lensedInput
    :: forall s f p
     . HP.InputType
    -> Lens' s String
    -> ((s -> s) -> f Unit)
    -> s
    -> HTML p (f Unit)
lensedInput t l q s =
    HH.input
        [ HP.type_ t
        , HP.value (s ^. l)
        , HE.onValueChange (Just <<< q <<< (l .~ _)) ]
