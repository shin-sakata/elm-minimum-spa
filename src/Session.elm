module Session exposing (Session)

import Browser.Navigation as Nav
import Html.Attributes exposing (..)
import Url


type alias Session =
    { key : Nav.Key
    , url : Url.Url
    }
