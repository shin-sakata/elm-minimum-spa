module Main exposing (main)

import Browser exposing (application)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.About as About
import Page.Home as Home
import Page.NotFound as NotFound
import Route exposing (Route)
import Session exposing (Session)
import Url


main : Program () Model Msg
main =
    application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Model
    = HomeModel Home.Model
    | AboutModel About.Model
    | NotFoundModel NotFound.Model


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        sess : Session
        sess =
            Session key url
    in
    pageInit (Route.router url) sess


pageInit : Route -> Session -> ( Model, Cmd Msg )
pageInit route sess =
    case route of
        Route.Home ->
            Home.init sess |> subToMain HomeModel HomeMsg

        Route.About ->
            About.init sess |> subToMain AboutModel AboutMsg

        Route.NotFound ->
            NotFound.init sess |> subToMain NotFoundModel NotFoundMsg


subToMain : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
subToMain toMainModel toMainMsg ( subModel, subCmd ) =
    ( toMainModel subModel
    , Cmd.map toMainMsg subCmd
    )


toSession : Model -> Session
toSession model =
    case model of
        HomeModel subModel ->
            Home.toSession subModel

        AboutModel subModel ->
            About.toSession subModel

        NotFoundModel subModel ->
            NotFound.toSession subModel



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | HomeMsg Home.Msg
    | AboutMsg About.Msg
    | NotFoundMsg NotFound.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl (toSession model).key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( UrlChanged url, _ ) ->
            pageInit (Route.router url) (toSession model)

        ( HomeMsg subMsg, HomeModel subModel ) ->
            Home.update subMsg subModel |> subToMain HomeModel HomeMsg

        ( AboutMsg subMsg, AboutModel subModel ) ->
            About.update subMsg subModel |> subToMain AboutModel AboutMsg

        -- 違うページのコマンドは実質バグってるので無視
        ( _, _ ) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        HomeModel subModel ->
            Sub.map HomeMsg (Home.subscriptions subModel)

        AboutModel subModel ->
            Sub.map AboutMsg (About.subscriptions subModel)

        NotFoundModel subModel ->
            Sub.map NotFoundMsg (NotFound.subscriptions subModel)



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model of
        HomeModel subModel ->
            Home.view subModel

        AboutModel subModel ->
            About.view subModel

        NotFoundModel subModel ->
            NotFound.view subModel
