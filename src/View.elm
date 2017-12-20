module View exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Types exposing (..)
import Accessor exposing (..)
import View.Config exposing (..)
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


boardColumns : Size -> List Length
boardColumns { width } =
    List.repeat width <| px boxSize


boardRows : Size -> List Length
boardRows { height } =
    List.repeat height <| px boxSize


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
                el BoxStyle [] <|
                    -- (text <| toString ( x, y ))
                    empty
            }


player : Player -> Element Styles Variation Msg
player { coord, direction } =
    (el PlayerBoxStyle
        [ width <| px boxSize
        , height <| px boxSize
        , moveDown <| toFloat <| boardPadding + coord.y * (boardSpacing + boxSize)
        , moveRight <| toFloat <| boardPadding + coord.x * (boardSpacing + boxSize)
        ]
     <|
        circle (boxSize * 0.3)
            PlayerStyle
            [ center, verticalCenter ]
            -- (text "player")
            empty
    )
        |> within
            [ el MoveAngleStyle
                [ width <| px boxSize
                , height <| px boxSize
                , vary UpVar <| direction == Up
                , vary DownVar <| direction == Down
                , vary RightVar <| direction == Right
                , vary LeftVar <| direction == Left
                ]
              <|
                Symbol.angleElement
            ]
