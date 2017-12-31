module Controller.Keyboard exposing (subscriptions)

import Keyboard exposing (KeyCode)
import Keyboard.Key as Key
import Types exposing (..)
import Controller.Types as Controller exposing (Orders)


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.downs
        (\code ->
            case ( keyCodeToOrder code, model.player.direction ) of
                ( Ok Controller.Action, _ ) ->
                    Cultivate model.player

                ( Ok Controller.Up, Up ) ->
                    MovePlayer model.player.coord Up

                ( Ok Controller.Down, Down ) ->
                    MovePlayer model.player.coord Down

                ( Ok Controller.Right, Right ) ->
                    MovePlayer model.player.coord Right

                ( Ok Controller.Left, Left ) ->
                    MovePlayer model.player.coord Left

                ( Ok Controller.Up, _ ) ->
                    ChangePlayerDirection Up

                ( Ok Controller.Down, _ ) ->
                    ChangePlayerDirection Down

                ( Ok Controller.Right, _ ) ->
                    ChangePlayerDirection Right

                ( Ok Controller.Left, _ ) ->
                    ChangePlayerDirection Left

                ( Err err, _ ) ->
                    let
                        _ =
                            Debug.log "keyCodeToOrder error" err
                    in
                        NoOp
        )


keyCodeToOrder : KeyCode -> Result String Orders
keyCodeToOrder code =
    case Key.fromCode code of
        Key.A ->
            Ok Controller.Action

        Key.Up ->
            Ok Controller.Up

        Key.Down ->
            Ok Controller.Down

        Key.Left ->
            Ok Controller.Left

        Key.Right ->
            Ok Controller.Right

        Key.K ->
            Ok Controller.Up

        Key.J ->
            Ok Controller.Down

        Key.H ->
            Ok Controller.Left

        Key.L ->
            Ok Controller.Right

        key ->
            Err ("Unused key: " ++ toString key ++ ", " ++ toString code)
