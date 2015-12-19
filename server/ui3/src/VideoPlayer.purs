module VideoPlayer (
  State(), initialState, Query(IsPlaying, GetCurrentTime), videoPlayer
  ) where

import Prelude

import Halogen
import qualified Halogen.HTML.Indexed as H
import qualified Halogen.HTML.Properties.Indexed as P

import Definitions

type State =
  { url :: String
  , playing :: Boolean
  , currentTime :: Time
  }

initialState :: String -> State
initialState url = { url: url, playing: false, currentTime: (Time 0.0) }

data Query next
  = IsPlaying (Boolean -> next)
  | GetCurrentTime (Time -> next)

videoPlayer :: Component State Query AppAff
videoPlayer = component render eval
  where
    render :: State -> ComponentHTML Query
    render state =
      H.video [ P.src state.url, controls true ] []

    eval :: Natural Query (ComponentDSL State Query AppAff)
    eval (IsPlaying next) = do
      playing <- gets _.playing
      pure (next playing)

    eval (GetCurrentTime next) = do
      time <- gets _.currentTime
      pure (next time)
