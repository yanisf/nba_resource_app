class ApplicationController < ActionController::Base
<<<<<<< HEAD
  protect_from_forgery with: :exception
  include SessionsHelper
end
=======
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
>>>>>>> 09c7440c26b203b2ebbea8a6c19baf2311524133
