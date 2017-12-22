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


board : Model -> Element Styles variation Msg
board ({ board, size } as model) =
    grid Board
        [ spacing boardSpacing, padding boardPadding ]
        { columns = List.repeat size.width <| px boxSize
        , rows = List.repeat size.height <| px boxSize
        , cells = List.map (box >> cell) board
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
        ]
     <|
        circle (boxSize * 0.3)
            PlayerStyle
            [ center, verticalCenter ]
            -- (text "player")
            empty
    )
        |> within
            [ el (MoveAngleStyle direction)
                [ width <| px boxSize, height <| px boxSize ]
                Symbol.angleElement
            ]
