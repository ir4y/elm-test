module MyApp (init, view, update) where
import EditForm
import ItemList
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on ,targetChecked)


type alias Model =
  { editForm: EditForm.Model
  , itemList: ItemList.Model
  }


type Action
  = EF EditForm.Action
  | IL ItemList.Action
  | Add
  | Del
  | Set
  | CheckAll Bool
  | Load10000


init : Model
init =
  Model (EditForm.init "" "") []


getRandomItems: Int -> ItemList.Model
getRandomItems count =
  List.repeat count (EditForm.init "foo" "bar")


update : Action -> Model -> Model
update action model =
  case action of
    EF act ->
      { model | editForm <- EditForm.update act model.editForm }

    IL act ->
      { model | itemList <- ItemList.update act model.itemList }

    Add ->
      { model | itemList <- model.itemList ++ [model.editForm]
              , editForm <- EditForm.init "" "" }
    Del ->
      { model | itemList <- List.filter (.selected >> not) model.itemList }

    Set ->
      let updateItem item =
        if item.selected
          then model.editForm
          else item
      in { model | itemList <- List.map updateItem model.itemList
                 , editForm <- EditForm.init "" "" }

    CheckAll value ->
      { model | itemList <- List.map (\item -> { item | selected <- value }) model.itemList }

    Load10000 ->
      { model | itemList <- model.itemList ++ (getRandomItems 10000) }


isAllCheck : ItemList.Model -> Bool
isAllCheck items =
  List.all .selected items


view : Signal.Address Action -> Model -> Html
view address model  =
  div []
      [ button [ onClick address Load10000 ] [text "Load 10 000 items"]
      , EditForm.view (Signal.forwardTo address EF) model.editForm
      , p [] [ input [ type' "checkbox"
                     , checked (isAllCheck model.itemList)
                     , on "change" targetChecked (Signal.message address << CheckAll)
                     ] []
             , button [onClick address Add] [text "+"]
             , button [onClick address Del] [text "-"]
             , button [onClick address Set] [text "\\/"]
             ]
      , ItemList.view (Signal.forwardTo address IL)  model.itemList
      ]
