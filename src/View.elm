module View exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on)
import Types exposing (..)
import Types.Accessor as Accessor
import View.Config exposing (..)
import View.StyleSheet exposing (..)
import View.Svg.Symbol as Symbol exposing (Symbol(..))
import View.MessageArea
import Rocket exposing ((=>))
import Monocle.Lens as Lens
import Json.Decode as Json


view : Model -> Html Msg
view model =
    Element.viewport styleSheet <|
        column None
            [ width Attrs.fill, height Attrs.fill ]
            [ html <| Symbol.symbols
            , game model
            ]


game : Model -> Element Styles variation Msg
game model =
    namedGrid None
        [ width Attrs.fill
        , height Attrs.fill
        , spacing 10
        , padding 10
        ]
        { columns = [ percent 60, percent 40 ]
        , rows = [ percent 100 => [ span 1 "board", span 1 "message" ] ]
        , cells =
            [ named "board" <| board model
            , named "message" <| View.MessageArea.view model
            ]
        }


board : Model -> Element Styles variation Msg
board ({ board, size } as model) =
    grid Board
        [ clip, spacing boardSpacing, padding boardPadding ]
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
        , on "transitionend" <| Json.succeed TransitionEnd
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


messageArea : List Message -> Element Styles variation Msg
messageArea messages =
    column MessageAreaStyle
        [ width Attrs.fill
        , height Attrs.fill
        , spacing 10
        ]
    <|
        List.map (\{ content, agent } -> text content) messages
