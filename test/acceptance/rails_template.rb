gem "elm-rails", path: ".."

file "app/assets/elm/Hello.elm", <<-ELM
module Hello exposing (..)
import Html exposing (text)
main = text "Hello, World"
ELM

file "app/assets/javascripts/application.js", <<-JS
//= require Hello
JS

