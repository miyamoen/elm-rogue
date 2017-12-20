module View.Svg.Symbol exposing (toId, Symbol(..), symbols, angleElement)

import Html exposing (Html)
import Element exposing (Element, html)
import Svg exposing (Svg, Attribute)
import Svg.Attributes
import TypedSvg exposing (..)
import TypedSvg.Attributes exposing (viewBox, points, xlinkHref)
import TypedSvg.Attributes.InPx exposing (x, y, width, height, strokeWidth)
import View.Config exposing (..)
import Rocket exposing ((=>))


type Symbol
    = Angle


toSelector : Symbol -> String
toSelector symbol =
    "#" ++ toId symbol


toId : Symbol -> String
toId symbol =
    case symbol of
        Angle ->
            "elm-rogue-angle"


id : Symbol -> Attribute msg
id symbol =
    Svg.Attributes.id <| toId symbol


symbols : Html msg
symbols =
    svg [ viewBox 0 0 100 100, width 0, height 0 ]
        [ defs []
            [ angle ]
        ]


angle : Svg msg
angle =
    symbol
        [ viewBox 0 0 100 100
        , id Angle
        ]
        [ polyline
            [ points
                [ 10 => 50
                , 50 => 10
                , 90 => 50
                ]
            ]
            []
        ]


angleElement : Element s v m
angleElement =
    svg [ viewBox 0 0 100 100, width boxSize, height boxSize ]
        [ use [ xlinkHref <| toSelector Angle ] [] ]
        |> html
