module View.Helper exposing (..)

import Json.Decode as Json
import Element exposing (Attribute)
import Element.Events exposing (on)


onTransitionEnd : (String -> msg) -> Attribute variation msg
onTransitionEnd tagger =
    on "transitionend" <| Json.map tagger propertyName



propertyName : Json.Decoder String
propertyName =
    Json.field "propertyName" Json.string
