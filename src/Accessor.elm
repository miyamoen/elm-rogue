module Accessor exposing (..)

import Types exposing (..)
import Monocle.Lens as Lens exposing (Lens)


playerX : Lens Player Int
playerX =
    Lens.compose playerCoord coordX


playerY : Lens Player Int
playerY =
    Lens.compose playerCoord coordY


playerCoord : Lens Player Coord
playerCoord =
    { get = .coord
    , set = \coord player -> { player | coord = coord }
    }


playerDirection : Lens Player Direction
playerDirection =
    { get = .direction
    , set = \direction player -> { player | direction = direction }
    }


coordX : Lens Coord Int
coordX =
    { get = .x
    , set = \x coord -> { coord | x = x }
    }


coordY : Lens Coord Int
coordY =
    { get = .y
    , set = \y coord -> { coord | y = y }
    }
