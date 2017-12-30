module View exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on)
import Types exposing (..)
import View.StyleSheet exposing (..)
import View.MessageArea
import View.Header
import View.Footer
import View.Board
import View.Svg.Symbol as Symbol exposing (Symbol(..))
import Rocket exposing ((=>))


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
    namedGrid MainStyle
        [ width Attrs.fill
        , height Attrs.fill
        , spacing 10
        , padding 10
        ]
        { columns = columns model.windowSize
        , rows = rows model.windowSize
        , cells =
            [ named "board" <| View.Board.view model
            , named "message" <| View.MessageArea.view model
            , named "header" <| View.Header.view model
            , named "footer" <| View.Footer.view model
            ]
        }


spacingSize : number
spacingSize =
    10


paddingSize : number
paddingSize =
    10


columns : Size -> List Length
columns { width } =
    let
        restWidth =
            (toFloat width) - 1 * spacingSize - 2 * paddingSize
    in
        [ px <| restWidth * 0.6, px <| restWidth * 0.4 ]


rows : Size -> List ( Length, List NamedGridPosition )
rows { height } =
    let
        restHeight =
            (toFloat height) - 2 * spacingSize - 2 * paddingSize
    in
        [ px (restHeight * 0.1) => [ spanAll "header" ]
        , px (restHeight * 0.8) => [ span 1 "board", span 1 "message" ]
        , px (restHeight * 0.1) => [ span 1 "board", span 1 "footer" ]
        ]



-- 824.67
-- 59.800000000000004 + 59.800000000000004 + 478.40000000000003
