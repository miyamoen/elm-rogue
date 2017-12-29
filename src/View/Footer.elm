module View.Footer exposing (view)

import Types exposing (..)
import View.StyleSheet exposing (..)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on)
import Element.Keyed as Keyed
import Rocket exposing ((=>))


view : Model -> Element Styles variation Msg
view { round, state } =
    row HeaderStyle
        [ spacing 10
        , padding 10
        ]
        [ newTab "http://logomakr.com" <| text "LogoMakr.com"
        ]
