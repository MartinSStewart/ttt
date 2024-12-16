port module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Json.Decode as D
import Json.Encode as E
import Lamdera exposing (ClientId)
import Random
import Time
import Tutorial.Types exposing (TutorialStep)
import Url exposing (Url)



-- PORTS


port storeLocalStorage_ : String -> Cmd msg


port receiveLocalStorage_ : (String -> msg) -> Sub msg


port getLocalStorageValue_ : String -> Cmd msg


port receiveLocalStorageValue_ : (String -> msg) -> Sub msg


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


type alias Move =
    { boardIndex : Int
    , cellIndex : Int
    , player : Player
    }


type alias BigBoard =
    { boards : List SmallBoard
    , currentPlayer : Player
    , activeBoard : Maybe Int
    , winner : Maybe Player
    , initialPlayer : Player
    }


type BotDifficulty
    = Easy
    | Medium
    | Hard
    | Elite


type GameMode
    = WithFriend
    | WithBot BotDifficulty
    | OnlineGame


type Route
    = Home
    | Game GameMode


type Language
    = FR
    | EN


type GameResult
    = Won
    | Lost
    | Drew
    | Ongoing


type alias FrontendModel =
    { key : Key
    , board : BigBoard
    , route : Route
    , language : Language
    , darkMode : Bool
    , moveHistory : List Move
    , currentMoveIndex : Int
    , rulesModalVisible : Bool
    , humanPlaysFirst : Bool
    , frClickCount : Int
    , debuggerVisible : Bool
    , debuggerPosition : Position
    , isDraggingDebugger : Bool
    , dragOffset : Position
    , debuggerSize : Size
    , isResizingDebugger : Bool
    , localStorageValues : Dict String String
    , selectedDifficulty : Maybe BotDifficulty
    , onlinePlayer : Maybe Player
    , showAbandonConfirm : Bool
    , gameResult : GameResult
    , tutorialState : Maybe TutorialStep
    , botDifficultyMenuOpen : Bool
    , botThinking : Bool
    , inMatchmaking : Bool
    , onlineOpponent : Maybe ClientId
    }


type alias BackendModel =
    { message : String
    , matchmakingQueue : List ClientId
    , activeGames : List ( ClientId, ClientId, BigBoard )
    , seed : Random.Seed
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOp
    | CellClicked Int Int
    | BotMove
    | RestartGame
    | StartGameWithFriend
    | StartGameWithBot
    | SelectBotDifficulty BotDifficulty
    | StartWithPlayer Bool
    | ReturnToMenu
    | CancelBotDifficulty
    | PlayForMe
    | ChangeLanguage Language
    | CloseDebugger
    | UndoMove
    | RedoMove
    | ToggleDarkMode
    | ToggleDebugMode
    | ReceivedLocalStorage { language : String, darkMode : Bool }
    | StartDraggingDebugger Float Float
    | StopDraggingDebugger
    | DragDebugger Float Float
    | StartResizingDebugger
    | StopResizingDebugger
    | ResizeDebugger Float Float
    | ReceivedLocalStorageValue String String
    | ToggleRulesModal
    | StartOnlineGame
    | StartWithRandomPlayer
    | GotTime Time.Posix
    | Tick Time.Posix
    | ShowAbandonConfirm
    | HideAbandonConfirm
    | ConfirmAbandon
    | StartTutorial
    | NextTutorialStep
    | SkipTutorial
    | CompleteTutorial


type ToBackend
    = NoOpToBackend
    | JoinMatchmaking
    | LeaveMatchmaking
    | AbandonGame
    | MakeMove Int Int Player


type BackendMsg
    = NoOpBackendMsg
    | GotInitialTime Time.Posix


type ToFrontend
    = NoOpToFrontend
    | GameFound { opponentId : ClientId, playerRole : Player }
    | OpponentMove Move
    | OpponentLeft



-- HELPERS


languageToString : Language -> String
languageToString lang =
    case lang of
        FR ->
            "FR"

        EN ->
            "EN"


stringToLanguage : String -> Language
stringToLanguage str =
    case str of
        "EN" ->
            EN

        _ ->
            FR


type alias Position =
    { x : Float
    , y : Float
    }


type alias Size =
    { width : Float
    , height : Float
    }
