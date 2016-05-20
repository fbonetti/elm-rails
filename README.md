[![Build Status](https://travis-ci.org/fbonetti/elm-rails.svg?branch=master)](http://travis-ci.org/fbonetti/elm-rails)

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

1. Define your elm modules in the `app/assets/elm` directory. Note that files that you want to load with `//= require` or `javascript_include_tag` must have a .js.elm extension.

    **app/assets/elm/Hello.js.elm**
    ```elm
    module Hello where
    
    import Graphics.Element exposing (show)
    
    port noun : String
    
    main =
      show ("Hello " ++ noun)
    ```

2. Use the view helper to insert your component into your view. Pass port values as a `Hash`.

    ```erb
    <h1>This is an Elm component!</h1>
    <%= javascript_include_tag 'Hello' %>
    <%= elm_embed('Elm.Hello', { noun: 'World!' }) %>
    ```
    
3. That's it!

### Configuration

If necessary, you may specify the path to the `elm-make` executable in an initializer.

    **config/initializers/elm-rails.rb**
    ```ruby
    Elm::Rails.elm_path_path = "bin/elm-make"
    ```

