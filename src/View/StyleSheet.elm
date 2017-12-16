module View.StyleSheet exposing (..)

import View.Colors as Colors
import Color.Mixing as Mixing
import Style exposing (..)
import Style.Font as Font
import Style.Color as Color
import Style.Shadow as Shadow
import Style.Border as Border
import Style.Transition as Transition exposing (Transition)
import Color exposing (Color)


type Styles
    = None
    | Board
    | BoxStyle
    | PlayerStyle
    | PlayerBoxStyle


styleSheet : StyleSheet Styles variation
styleSheet =
    Style.styleSheet
        [ style None []
        , style Board
            []
        , style BoxStyle
            [ Color.background Colors.moon
            ]
        , style PlayerStyle
            [ zIndex 1
            , Color.background Colors.primary
            ]
        , style PlayerBoxStyle
            [ Transition.all ]
        ]


zIndex : Int -> Property class variation
zIndex n =
    prop "z-index" (toString n)
