module View.StyleSheet exposing (..)

import View.Colors as Colors
import Color.Mixing as Mixing
import Style exposing (..)
import Style.Font as Font
import Style.Color as Color
import Style.Shadow as Shadow
import Style.Border as Border
import Style.Transition as Transition exposing (Transition)
import Color exposing (Color, rgba)
import Color.Convert exposing (colorToCssRgba)


type Styles
    = None
    | Board
    | BoxStyle
    | PlayerStyle
    | PlayerBoxStyle
    | MoveAngleStyle


type Variation
    = UpVar
    | DownVar
    | RightVar
    | LeftVar


styleSheet : StyleSheet Styles Variation
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
        , style MoveAngleStyle
            [ strokeFill Colors.info
            , strokeWidth 7
            , fill <| rgba 0 0 0 0
            , translate 0 -30 0
            , scale 0.7 0.7 1
            , variation UpVar []
            , variation DownVar
                [ rotate <| degrees 180 ]
            , variation RightVar
                [ rotate <| degrees 90 ]
            , variation LeftVar
                [ rotate <| degrees 270 ]
            ]
        ]


zIndex : Int -> Property class variation
zIndex n =
    prop "z-index" (toString n)


fill : Color -> Property class variation
fill color =
    prop "fill" <| colorToCssRgba color


strokeFill : Color -> Property class variation
strokeFill color =
    prop "stroke" <| colorToCssRgba color


strokeWidth : number -> Property class variation
strokeWidth w =
    prop "stroke-width" <| toString w
