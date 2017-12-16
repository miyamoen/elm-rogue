module Main exposing (..)

import Html
import View exposing (view)
import Types exposing (..)
import Accessor exposing (..)
import Rocket exposing ((=>), batchInit, batchUpdate)
import Monocle.Lens as Lens
import Keyboard
import Keyboard.Key as Key


---- MODEL ----


initBoard : Board
initBoard =
    [ Coord 0 0 => BaseBox
    , Coord 0 1 => BaseBox
    , Coord 0 2 => BaseBox
    , Coord 1 0 => BaseBox
    , Coord 1 1 => BaseBox
    , Coord 1 2 => BaseBox
    , Coord 2 0 => BaseBox
    , Coord 2 1 => BaseBox
    , Coord 2 2 => BaseBox
    ]


initPlayer : Player
initPlayer =
    { coord = Coord 2 2 }


init : ( Model, List (Cmd Msg) )
init =
    { board = initBoard
    , size = { width = 3, height = 3 }
    , player = initPlayer
    }
        => []



---- UPDATE ----


update : Msg -> Model -> ( Model, List (Cmd Msg) )
update msg model =
    case msg of
        NoOp ->
            model => []

        MovePlayer coord dir ->
            { model
                | player =
                    if coord == model.player.coord && playerCanMove dir model then
                        Lens.modify Accessor.playerCoord (\coord -> move dir coord) model.player
                    else
                        model.player
            }
                => []


playerCanMove : Direction -> Model -> Bool
playerCanMove dir { size, player } =
    let
        { x, y } =
            move dir player.coord
    in
        0 <= x && x < size.width && 0 <= y && y < size.height


move : Direction -> Coord -> Coord
move dir ({ x, y } as coord) =
    case dir of
        Up ->
            { coord | y = y - 1 }

        Down ->
            { coord | y = y + 1 }

        Right ->
            { coord | x = x + 1 }

        Left ->
            { coord | x = x - 1 }


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses
        (\code ->
            case Key.fromCode code of
                Key.Up ->
                    MovePlayer model.player.coord Up

                Key.Down ->
                    MovePlayer model.player.coord Down

                Key.Left ->
                    MovePlayer model.player.coord Left

                Key.Right ->
                    MovePlayer model.player.coord Right

                Key.K ->
                    MovePlayer model.player.coord Up

                Key.J ->
                    MovePlayer model.player.coord Down

                Key.H ->
                    MovePlayer model.player.coord Left

                Key.L ->
                    MovePlayer model.player.coord Right

                key ->
                    let
                        _ =
                            Debug.log "unused key" key

                        _ =
                            Debug.log "unused key code" code
                    in
                        NoOp
        )



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init |> batchInit
        , update = update >> batchUpdate
        , subscriptions = subscriptions
        }
