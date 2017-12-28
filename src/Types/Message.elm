module Types.Message exposing (..)

import Types exposing (..)


init : List Message
init =
    [ Message 0 WorldAgent "elm-rogue got started!" ]


nextIndex : List Message -> Int
nextIndex messages =
    List.head messages
        |> Maybe.map (\message -> message.index + 1)
        |> Maybe.withDefault 0


addPlayerMoveMessage : Player -> List Message -> List Message
addPlayerMoveMessage player messages =
    Message
        (nextIndex messages)
        (PlayerAgent player)
        ("move to " ++ coordToString player.coord)
        :: messages


coordToString : Coord -> String
coordToString { x, y } =
    "( " ++ Basics.toString x ++ ", " ++ Basics.toString y ++ " )"
