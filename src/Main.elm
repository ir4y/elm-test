import EditForm exposing (init, update, view)
import StartApp.Simple exposing (start)


main =
  start
    { model = init "hello" "world"
    , update = update
    , view = view
    }
