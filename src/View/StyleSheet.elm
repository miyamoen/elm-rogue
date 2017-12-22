module View.StyleSheet exposing (..)

import Types exposing (..)
import View.Config exposing (..)
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
    | BoxStyle BoxStatus
    | PlayerStyle
    | PlayerBoxStyle
    | MoveAngleStyle Direction


styleSheet : StyleSheet Styles variation
styleSheet =
    Style.styleSheet
        [ style None []
        , style Board
            []
        , style (BoxStyle BaseBox)
            [ Color.background Colors.moon
            , zIndex -1
            ]
        , style (BoxStyle GroundBox)
            [ Color.background Colors.sanae
            ]
        , style (BoxStyle CultivatedBox)
            [ Color.background Colors.kurocha
            ]
        , style PlayerStyle
            [ zIndex 1
            , Color.background Colors.primary
            ]
        , style PlayerBoxStyle
            [ Transition.all ]
        , style (MoveAngleStyle Up)
            ([ rotate <| degrees 0
             , translate 0 (-0.3 * boxSize) 0
             ]
                ++ baseMoveAngleStyle
            )
        , style (MoveAngleStyle Down)
            ([ rotate <| degrees 180
             , translate 0 (0.3 * boxSize) 0
             ]
                ++ baseMoveAngleStyle
            )
        , style (MoveAngleStyle Right)
            ([ rotate <| degrees 90
             , translate (0.3 * boxSize) 0 0
             ]
                ++ baseMoveAngleStyle
            )
        , style (MoveAngleStyle Left)
            ([ rotate <| degrees 270
             , translate (-0.3 * boxSize) 0 0
             ]
                ++ baseMoveAngleStyle
            )
        ]


baseMoveAngleStyle : List (Property class variation)
baseMoveAngleStyle =
    [ strokeFill Colors.ink
    , strokeWidth 7
    , fill <| rgba 0 0 0 0
    , scale 0.7 0.7 1
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
