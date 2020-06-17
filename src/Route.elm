module Route exposing (Route(..), router)

import Url


type Route
    = Home
    | About
    | NotFound


router : Url.Url -> Route
router url =
    case url.path of
        "/" ->
            Home

        "/home" ->
            Home

        "/about" ->
            About

        _ ->
            NotFound
