module MyApp (init, view, update) where
import EditForm
import ItemList
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

type alias Model = { editForm: EditForm.Model
                   , itemList: ItemList.Model
                   }

type Action = EF EditForm.Action | IL ItemList.Action | Add | Del | Set

init = Model (EditForm.init "" "") []

update : Action -> Model -> Model
update action model =
    case action of
        EF act -> { model | editForm <- EditForm.update act model.editForm }
        IL act -> { model | itemList <- ItemList.update act model.itemList }
        Add -> {model | itemList <- model.itemList ++ [model.editForm]}
        Del -> {model | itemList <- List.filter (\item -> not item.selected) model.itemList}
        Set -> let updateItem item =
                    if item.selected
                       then model.editForm
                       else item
               in {model | itemList <- List.map updateItem model.itemList}

view : Signal.Address Action -> Model -> Html
view address model  = div []
                          [ EditForm.view (Signal.forwardTo address EF) model.editForm
                          , p [] [ button [onClick address Add] [text "+"]
                                 , button [onClick address Del] [text "-"]
                                 , button [onClick address Set] [text "\\/"]
                                 ]
                          , ItemList.view (Signal.forwardTo address IL)  model.itemList
                          ]
