module Types exposing (..)


type alias Model =
    { board : Board
    , size : Size
    , player : Player
    }


type alias Player =
    { coord : Coord
    }


type Msg
    = NoOp
    | MovePlayer Coord Direction


type Box
    = BaseBox


type alias Coord =
    { x : Int, y : Int }


type alias Board =
    List ( Coord, Box )


type alias Size =
    { width : Int
    , height : Int
    }


type Direction
    = Up
    | Down
    | Right
    | Left
