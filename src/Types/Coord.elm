module Types.Coord exposing (..)

import Types exposing (..)
import Types.Accessor as Accessor


move : Direction -> Coord -> Coord
move dir ({ x, y } as coord) =
    case dir of
        Up ->
            { coord | y = y - 1 }

        Down ->
            { coord | y = y + 1 }

        Left ->
            { coord | x = x - 1 }

        Right ->
            { coord | x = x + 1 }
