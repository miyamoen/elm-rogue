module Types exposing (..)


type alias Model =
    { board : Board
    , player : Player
    , round : Round
    , state : GameState
    , messages : List Message
    , windowSize : Size
    }


type GameState
    = WaitingPlayerAction
    | AnimatingPlayerAction


type alias Round =
    Int


type alias Player =
    { coord : Coord
    , direction : Direction
    }


type Msg
    = NoOp
    | ResizeWindow Size
    | MovePlayer Coord Direction
    | ChangePlayerDirection Direction
    | Cultivate Player
    | PlayerAnimationEnd String


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
    { boxes : List Box
    , size : Size
    }


type alias Size =
    { width : Int
    , height : Int
    }


type Direction
    = Up
    | Down
    | Right
    | Left


type Agent
    = PlayerAgent Player
    | BoxAgent Box
    | WorldAgent


type alias Message =
    { index : Int
    , agent : Agent
    , content : String
    }
