module View.Board exposing (view)

import Types exposing (..)
import View.StyleSheet exposing (..)
import View.Config exposing (..)
import View.Svg.Symbol as Symbol exposing (Symbol(..))
import View.Helper exposing (..)
import Json.Decode as Json
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on)
import Element.Keyed as Keyed
import Rocket exposing ((=>))


view : Model -> Element Styles variation Msg
view model =
    column BoardAreaStyle
        [ center
        , verticalCenter
        ]
        [ board model ]


board : Model -> Element Styles variation Msg
board ({ board } as model) =
    grid None
        [ spacing boardSpacing, padding boardPadding ]
        { columns = List.repeat board.size.width <| px boxSize
        , rows = List.repeat board.size.height <| px boxSize
        , cells = List.map (box >> cell) board.boxes
        }
        |> within [ player model.player ]


box : Box -> GridPosition Styles variation Msg
box { coord, status } =
    { start = ( coord.x, coord.y )
    , width = 1
    , height = 1
    , content =
        case status of
            BaseBox ->
                el (BoxStyle BaseBox)
                    [ attribute "title" <| toString coord ]
                    empty

            GroundBox ->
                el (BoxStyle GroundBox) [] empty

            CultivatedBox ->
                el (BoxStyle CultivatedBox) [] empty
    }


player : Player -> Element Styles variation Msg
player { coord, direction } =
    (el PlayerBoxStyle
        [ width <| px boxSize
        , height <| px boxSize
        , moveDown <| toFloat <| boardPadding + coord.y * (boardSpacing + boxSize)
        , moveRight <| toFloat <| boardPadding + coord.x * (boardSpacing + boxSize)
        , onTransitionEnd PlayerAnimationEnd
        ]
     <|
        circle (boxSize * 0.3)
            PlayerStyle
            [ center, verticalCenter ]
            empty
    )
        |> within
            [ el (MoveAngleStyle direction)
                [ width <| px boxSize, height <| px boxSize ]
                Symbol.angleElement
            ]
