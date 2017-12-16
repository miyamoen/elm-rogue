module View exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Types exposing (..)
import Accessor exposing (..)
import View.StyleSheet exposing (..)
import Rocket exposing ((=>))
import Monocle.Lens as Lens


view : Model -> Html Msg
view ({ board, size } as model) =
    Element.viewport styleSheet <|
        (grid Board
            [ spacing boardSpacing, padding boardPadding ]
            { columns = boardColumns size
            , rows = boardRows size
            , cells = List.map (box >> cell) board
            }
            |> within [ player model.player ]
        )


boardPadding : number
boardPadding =
    20


boardSpacing : number
boardSpacing =
    10


boardColumns : Size -> List Length
boardColumns { width } =
    List.repeat width <| px 100


boardRows : Size -> List Length
boardRows { height } =
    List.repeat height <| px 100


box : ( Coord, Box ) -> GridPosition Styles variation Msg
box ( { x, y }, boxType ) =
    case boxType of
        BaseBox ->
            { start = ( x, y )
            , width = 1
            , height = 1
            , content =
                el BoxStyle [] <| text <| toString ( x, y )
            }


playerGrid : Player -> GridPosition Styles variation Msg
playerGrid p =
    { start = ( playerX.get p, playerY.get p )
    , width = 1
    , height = 1
    , content =
        row PlayerBoxStyle
            [ center
            , verticalCenter
            ]
            [ circle 30 PlayerStyle [] <| text "player" ]
    }


player : Player -> Element Styles variation Msg
player { coord } =
    el PlayerBoxStyle
        [ width <| px 100
        , height <| px 100
        , moveDown <| toFloat <| boardPadding + coord.y * (boardSpacing + 100)
        , moveRight <| toFloat <| boardPadding + coord.x * (boardSpacing + 100)
        ]
    <|
        circle 30 PlayerStyle [ center, verticalCenter ] <|
            text "player"
