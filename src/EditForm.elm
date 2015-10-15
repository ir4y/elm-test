module EditForm (Model, init, Action, update, view) where
import MyInput
import Html exposing (..)
import Html.Events exposing (on, targetValue)
import Html.Attributes exposing (value)



type alias Model = { name: MyInput.Model
                   , externalId: MyInput.Model
                   , selected: Bool}

init: String -> String -> Model
init name externalId = Model (MyInput.init name) (MyInput.init externalId) False

type Action = Name MyInput.Action | ExternalId MyInput.Action

update : Action -> Model -> Model
update action model =
    case action of
        Name act -> { model | name <- MyInput.update act model.name }
        ExternalId act -> { model | externalId <- MyInput.update act model.externalId }


view : Signal.Address Action -> Model -> Html
view address model  = div []
                          [ p [] [ label [] [text "Name:"]
                                 , MyInput.view (Signal.forwardTo address Name) model.name
                                 ]
                          , p [] [ label [] [text "External id:"]
                                 , MyInput.view (Signal.forwardTo address ExternalId) model.externalId
                                 ]
                          ]
