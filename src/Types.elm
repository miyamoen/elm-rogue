module Types exposing (..)


type alias Model =
    { board : Board
    , size : Size
    , player : Player
    , round : Round
    , state : GameState
    }


type GameState
    = WaitingPlayerAction
    | PlayerActionResult
    | BoxAction
    | BoxActionResult


type alias Round =
    Int


type alias Player =
    { coord : Coord
    , direction : Direction
    }


type Msg
    = NoOp
    | MovePlayer Coord Direction
    | ChangePlayerDirection Direction
    | Cultivate Player


type alias Box =
    { coord : Coord
    , status : BoxStatus
    }


type BoxStatus
    = BaseBox
    | GroundBox
    | CultivatedBox


type alias Coord =
    { x : Int, y : Int }


type alias Board =
    List Box


type alias Size =
    { width : Int
    , height : Int
    }


type Direction
    = Up
    | Down
    | Right
    | Left
