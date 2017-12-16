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
        grid Board
            [ spacing 10, padding 20 ]
            { columns = boardColumns size
            , rows = boardRows size
            , cells =
                board
                    |> List.map box
                    |> (::) (player model.player)
                    |> List.map cell
            }


boardColumns : Size -> List Length
boardColumns { width } =
    List.repeat width <| px 100


boardRows : Size -> List Length
boardRows { height } =
    List.repeat height <| px 100


box : ( Coord, Box ) -> GridPosition Styles variation Msg
box ( { x, y }, boxType ) =
    case boxType of
        Simple ->
            { start = ( x, y )
            , width = 1
            , height = 1
            , content =
                el BoxStyle [] <| text <| toString ( x, y )
            }


player : Player -> GridPosition Styles variation Msg
player p =
    { start = ( playerX.get p, playerY.get p )
    , width = 1
    , height = 1
    , content =
        row None
            [ center
            , verticalCenter
            ]
            [ circle 30 PlayerStyle [] <| text "player" ]
    }
