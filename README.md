# GCal Rails Test

_This is a test of the Google Calendar API and Google OAuth2 login._

_GCal implemented via a Frankenstein of the getting started guides [here](https://developers.google.com/google-apps/calendar/quickstart/ruby) and [here](https://developers.google.com/api-client-library/ruby/auth/web-app)._

_Google login tutorial is [here](https://medium.com/@ajayramesh/social-login-with-omniauth-and-rails-5-0-ad2bbd2a998e)._
* This tutorial requires some changes:
  1. Tutorial places API info in initializer file which seems bad to me. My solution:
    1. Add `gem 'dotenv-rails'` to "development/test" section of `Gemfile` and `bundle`
    2. Create a `.env` file
      ```
      GOOGLE_CLIENT_ID = "[your_client_id]"
      GOOGLE_CLIENT_SECRET = "[your_client_secret]"
      ```
    3. Use these in `config/initializers/omniauth.rb` instead of actual id/secret:
      ```ruby
      Rails.application.config.middleware.use OmniAuth::Builder do
        provider :google_oauth2, "#{ENV['GOOGLE_CLIENT_ID']}", "#{ENV['GOOGLE_CLIENT_SECRET']}"
      end
      ```
  2. In `app/views/home/show.html.erb`, change code to the following:
    ```html
    <h1> Welcome, please login to continue </h1>
    <a href="/auth/google_oauth2">Sign in with Google</a>
    ```
