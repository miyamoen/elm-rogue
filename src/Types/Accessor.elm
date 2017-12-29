module Types.Accessor exposing (..)

import Types exposing (..)
import Monocle.Lens as Lens exposing (Lens)
import Monocle.Optional as Optional exposing (Optional)
import List.Extra exposing (find)


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


boardBox : Coord -> Optional Board Box
boardBox coord =
    { getOption = \{ boxes } -> find (\box -> box.coord == coord) boxes
    , set =
        \new ({ boxes } as board) ->
            { board
                | boxes =
                    List.map
                        (\old ->
                            if old.coord == new.coord then
                                new
                            else
                                old
                        )
                        boxes
            }
    }


boxBoxStatus : Lens Box BoxStatus
boxBoxStatus =
    { get = .status
    , set = \status box -> { box | status = status }
    }


boardBoxStatus : Coord -> Optional Board BoxStatus
boardBoxStatus coord =
    Optional.composeLens
        (boardBox coord)
        boxBoxStatus
