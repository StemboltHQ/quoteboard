class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :vote_types

  def vote_types
    [["I hate it", :hate_it],
     ["I'm against it", :against_it],
     ["I like it", :like_it],
     ["I love it", :love_it]
    ]
  end
end
