module View exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Types exposing (..)
import Accessor exposing (..)
import View.StyleSheet exposing (..)
import View.Svg.Symbol as Symbol exposing (Symbol(..))
import Rocket exposing ((=>))
import Monocle.Lens as Lens


view : Model -> Html Msg
view model =
    Element.viewport styleSheet <|
        column None
            []
            [ html <| Symbol.symbols
            , board model
            ]


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


board : Model -> Element Styles Variation Msg
board ({ board, size } as model) =
    grid Board
        [ spacing boardSpacing, padding boardPadding ]
        { columns = boardColumns size
        , rows = boardRows size
        , cells = List.map (box >> cell) board
        }
        |> within [ player model.player ]


box : ( Coord, Box ) -> GridPosition Styles Variation Msg
box ( { x, y }, boxType ) =
    case boxType of
        BaseBox ->
            { start = ( x, y )
            , width = 1
            , height = 1
            , content =
                el BoxStyle [] <| text <| toString ( x, y )
            }


playerGrid : Player -> GridPosition Styles Variation Msg
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


player : Player -> Element Styles Variation Msg
player { coord, direction } =
    (el PlayerBoxStyle
        [ width <| px 100
        , height <| px 100
        , moveDown <| toFloat <| boardPadding + coord.y * (boardSpacing + 100)
        , moveRight <| toFloat <| boardPadding + coord.x * (boardSpacing + 100)
        ]
     <|
        circle 30
            PlayerStyle
            [ center, verticalCenter ]
            (text "player")
    )
        |> within
            [ el MoveAngleStyle
                [ vary UpVar <| direction == Up
                , vary DownVar <| direction == Down
                , vary RightVar <| direction == Right
                , vary LeftVar <| direction == Left
                ]
              <|
                Symbol.angleElement
            ]
