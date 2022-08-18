# elm-rails

[![Build Status](https://github.com/fbonetti/elm-rails/actions/workflows/ci.yml/badge.svg)](https://github.com/fbonetti/elm-rails/actions/workflows/ci.yml)

`elm-rails` makes it easy to use [Elm](http://elm-lang.org) modules in your Ruby on Rails applications. This project was heavily inspired by [react-rails](https://github.com/reactjs/react-rails).

## Compatibility

Only works with Elm 0.19.

This gem is tested against Ruby versions 2.2, 2.3, 2.4, and 2.5; and Rails versions 4.2, 5.0, and 5.1. It _may_ work on other versions, and if you want to open a PR adding tests against those versions they would be welcome.

## Installation

1. Add elm-rails to your `Gemfile` and run `bundle install`

    ```ruby
    gem "elm-rails"
    ```

2. Create a new directory to house all Elm modules

    ```bash
    mkdir app/assets/elm
    ```

3. Update `.gitignore` to ignore elm files

    ```
    /elm-stuff
    ```

## Usage

1. Define your elm modules in the `app/assets/elm` directory.

    **app/assets/elm/Hello.elm**
    ```elm
    module Hello exposing (..)

    import Html exposing (text)

    port noun : String

    main =
      text ("Hello " ++ noun)
    ```

2. Open your `app/assets/javascripts/application.js` and require your `Hello.elm`.
  ```
  //= require Hello
  ```

3. Use the view helper to insert your component into your view. Pass port values as a `Hash`.

    ```erb
    <h1>This is an Elm component!</h1>
    <%= elm_embed('Elm.Hello', { noun: 'World!' }) %>
    ```

4. That's it!

## Configuration

By default, elm-rails uses [elm-compiler](https://github.com/fbonetti/ruby-elm-compiler) under the hood, which will use the version of `elm` available in your system path, and then installing its own copy in /tmp if needed. If you wish, you may configure this path in an initializer:
    **config/initializers/elm_compiler.rb**
    ```erb
    Elm::Compiler.elm_path = "bin/elm"
    ```

