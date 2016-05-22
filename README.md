# elm-rails

`elm-rails` makes it easy to use [Elm](http://elm-lang.org) modules in your Ruby on Rails applications. This project was heavily inspired by [react-rails](https://github.com/reactjs/react-rails).

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

### Usage

1. Define your elm modules in the `app/assets/elm` directory.

    **app/assets/elm/Hello.elm**
    ```elm
    module Hello where

    import Graphics.Element exposing (show)

    port noun : String

    main =
      show ("Hello " ++ noun)
    ```

2. Open your `app/assets/javascript.js` and require your `Hello.elm`.
  ```
  //= require Hello
  ```

3. Use the view helper to insert your component into your view. Pass port values as a `Hash`.

    ```erb
    <h1>This is an Elm component!</h1>
    <%= elm_embed('Elm.Hello', { noun: 'World!' }) %>
    ```

4. That's it!

### Configuration

There is nothing to configure, but you should have Elm installed in your system
and `elm-make` must be availble in your path.
