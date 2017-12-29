module View.MessageArea exposing (view)

import Types exposing (..)
import View.StyleSheet exposing (..)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on)
import Element.Keyed as Keyed
import Rocket exposing ((=>))


view : Model -> Element Styles variation Msg
view { messages } =
    Keyed.column MessageAreaStyle
        [ spacing 10
        , padding 10
        , scrollbars
        ]
    <|
        List.map messageToElement messages


messageToElement : Message -> ( String, Element Styles variation Msg )
messageToElement { index, agent, content } =
    (toString index
        => row None
            [ spacing 6 ]
            [ text <| agentToString agent
            , text content
            ]
    )


agentToString : Agent -> String
agentToString agent =
    (case agent of
        WorldAgent ->
            "World"

        PlayerAgent player ->
            "player"

        BoxAgent box ->
            "Box{ x = " ++ toString box.coord.x ++ ", y = " ++ toString box.coord.y ++ " }"
    )
        |> \str -> "[" ++ str ++ "]"
