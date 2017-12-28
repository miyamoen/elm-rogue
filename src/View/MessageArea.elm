module MessageArea exposing (view)

import Types exposing (..)
import View.StyleSheet exposing (..)

import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on)

messageToElement : Message -> Element Styles variation Msg
messageToElement {agent, content}=
    Debug.crash "TODO"



agentToString agent =
    case agent of
        WorldAgent ->
            "World"
        PlayerAgent player ->
            "player"
        BoxAgent {coord} ->
            "Box{ x = " ++ coord.x ++ ", y = " ++ coord.y ++ " }"
