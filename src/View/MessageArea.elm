module View.MessageArea exposing (view)

import Types exposing (..)
import View.StyleSheet exposing (..)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on)


view : Model -> Element Styles variation Msg
view { messages } =
    column MessageAreaStyle
        [ width Attrs.fill
        , height Attrs.fill
        , spacing 10
        ]
    <|
        List.map messageToElement messages


messageToElement : Message -> Element Styles variation Msg
messageToElement { agent, content } =
    row None
        [ spacing 6 ]
        [ text <| agentToString agent
        , text content
        ]


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
