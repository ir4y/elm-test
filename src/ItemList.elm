module ItemList (init, view, update, Model, Action) where
import EditForm
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetChecked)

type alias Model = List EditForm.Model

type Action = Check Int Bool

init: List EditForm.Model -> Model
init items = items

update : Action -> Model -> Model
update action model =
    case action of
        Check currentIndex value ->
            let updateItem index item =
                if index == currentIndex
                   then {item | selected <- value}
                   else item
            in List.indexedMap updateItem model


view : Signal.Address Action -> List EditForm.Model -> Html
view address itemList  = table [] [tbody [] (List.indexedMap (viewItem address) itemList)]

viewItem : Signal.Address Action -> Int -> EditForm.Model -> Html
viewItem address index item = tr [] [ td [] [input [ type' "checkbox"
                                             , checked item.selected
                                             , on "change" targetChecked (Signal.message address << Check index) ] []]
                              , td [] [text item.name.value]
                              , td [] [text item.externalId.value]
                              ]
