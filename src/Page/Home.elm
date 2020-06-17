module Page.Home exposing (Model, Msg(..), init, subscriptions, toSession, update, view)

import Browser
import Html exposing (..)
import Session exposing (Session)



-- MODEL


type alias Model =
    Session


toSession : Model -> Session
toSession =
    identity


init : Session -> ( Model, Cmd Msg )
init sess =
    ( sess, Cmd.none )



-- UPDATE


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document msg
view _ =
    { title = "home"
    , body = [ h1 [] [ text "Home!" ] ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
