module Main exposing (..)

import Html
import Task
import Window
import View exposing (view)
import Types exposing (..)
import Types.Accessor as Accessor
import Types.Coord as Coord
import Types.Message as Message
import Rocket exposing ((=>), batchInit, batchUpdate)
import Monocle.Lens as Lens
import Monocle.Optional as Optional
import Controller.Keyboard
import List.Extra exposing (lift2)


---- MODEL ----


initBoard : Board
initBoard =
    let
        size =
            { width = 16, height = 16 }
    in
        { size = size
        , boxes =
            lift2 (\x y -> Box (Coord x y) GroundBox)
                (List.range 0 <| size.width - 1)
                (List.range 0 <| size.height - 1)
        }
            |> .set (Accessor.boardBoxStatus { x = 1, y = 1 }) CultivatedBox


initPlayer : Player
initPlayer =
    { coord = Coord 2 2
    , direction = Up
    }


init : ( Model, List (Cmd Msg) )
init =
    { board = initBoard
    , player = initPlayer
    , round = 0
    , state = WaitingPlayerAction
    , messages = Message.init
    , windowSize = { width = 1000, height = 1000 }
    }
        => [ Task.perform ResizeWindow Window.size ]



---- UPDATE ----


update : Msg -> Model -> ( Model, List (Cmd Msg) )
update msg model =
    case msg of
        NoOp ->
            model => []

        ResizeWindow size ->
            { model | windowSize = size } => []

        MovePlayer coord dir ->
            if model.state == WaitingPlayerAction && coord == model.player.coord && playerCanMove dir model then
                { model
                    | player =
                        Lens.modify Accessor.playerCoord (\coord -> Coord.move dir coord) model.player
                    , messages = Message.addPlayerMoveMessage model.player model.messages
                    , state = AnimatingPlayerAction
                }
                    => []
            else
                model => []

        ChangePlayerDirection dir ->
            { model | player = Lens.modify Accessor.playerDirection (\_ -> dir) model.player }
                => []

        Cultivate player ->
            let
                targetCoord =
                    Coord.move player.direction player.coord

                convert status =
                    case status of
                        GroundBox ->
                            CultivatedBox

                        _ ->
                            status
            in
                { model | board = Optional.modify (Accessor.boardBoxStatus targetCoord) convert model.board }
                    => []

        PlayerAnimationEnd _ ->
            if model.state == AnimatingPlayerAction then
                { model
                    | state = WaitingPlayerAction
                    , round = model.round + 1
                }
                    => []
            else
                model => []


playerCanMove : Direction -> Model -> Bool
playerCanMove dir { board, player } =
    let
        { x, y } =
            Coord.move dir player.coord
    in
        0 <= x && x < board.size.width && 0 <= y && y < board.size.height


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Controller.Keyboard.subscriptions model
        , Window.resizes ResizeWindow
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init |> batchInit
        , update = update >> batchUpdate
        , subscriptions = subscriptions
        }
