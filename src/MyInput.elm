module MyInput (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Events exposing (on, targetValue)
import Html.Attributes exposing (value)

type alias Model = { value : String }

init : String -> Model
init str = Model str

type Action = Change String

update : Action -> Model -> Model
update (Change str) model = { model | value <- str }

view : Signal.Address Action -> Model -> Html
view address model =
        input
            [ value model.value
            , on "input" targetValue (Signal.message address << Change)
            ]
            []
