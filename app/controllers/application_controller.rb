class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :vote_types

  def vote_types
    [["I hate it", -2],
     ["I'm against it", -1],
     ["I like it", 1],
     ["I love it", 2]
    ]
  end
end
