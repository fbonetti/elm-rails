# elm-rails

`elm-rails` makes it easy to use [Elm](elm-lang.org) modules in your Ruby on Rails applications. This project was heavily inspired by [react-rails](https://github.com/reactjs/react-rails).

## Installation

1. Add elm-rails to your `Gemfile` and run `bundle install`

    ```ruby
    gem "elm-rails"
    ```

2. Add the `elm_modules` asset to your `application.js` manifest file

    ```javascript
    //= require elm_modules
    ```

3. Create a new directory to house all Elm modules

    ```bash
    mkdir app/assets/elm
    ```

4. Disable asset caching in `config/environments/development.rb`

    ```ruby
    config.assets.configure do |env|
      env.cache = ActiveSupport::Cache.lookup_store(:null_store)
    end
    ```

5. Update `.gitignore` to ignore elm files

    ```
    /elm-stuff
    ```

### Usage

1. Define your elm modules in the `app/assets/elm` directory.

    **app/assets/Hello.elm**
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
    <%= elm_embed('Elm.Hello', { noun: 'World!' }) %>
    ```
    
3. That's it!
