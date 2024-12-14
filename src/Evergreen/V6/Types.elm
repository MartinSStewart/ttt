module Evergreen.V6.Types exposing (..)

import Browser
import Browser.Navigation
import Url


type Player
    = X
    | O


type CellState
    = Empty
    | Filled Player


type alias SmallBoard =
    { cells : List CellState
    , winner : Maybe Player
    }


type alias BigBoard =
    { boards : List SmallBoard
    , currentPlayer : Player
    , activeBoard : Maybe Int
    , winner : Maybe Player
    }


type BotDifficulty
    = Easy
    | Medium
    | Hard
    | Elite


type GameMode
    = WithFriend
    | WithBot BotDifficulty


type Route
    = Home
    | Game GameMode


type Language
    = FR
    | EN


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , board : BigBoard
    , route : Route
    , botDifficultyMenuOpen : Bool
    , language : Language
    , botThinking : Bool
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | CellClicked Int Int
    | RestartGame
    | StartGameWithFriend
    | StartGameWithBot
    | SelectBotDifficulty BotDifficulty
    | CancelBotDifficulty
    | ReturnToMenu
    | BotMove
    | ChangeLanguage Language


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
