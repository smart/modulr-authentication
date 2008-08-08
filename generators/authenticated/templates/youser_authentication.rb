module YouserAuthentication
  @@identity_model_name = "<%= file_name %>"
  
  def self.identity_model_name 
    @@identity_model_name
  end
  
  def identity_model_name=(something)
    @@identity_model_name = (something)
  end

  #this is the top of the super chain, if it gets here return null
  def login
    nil
  end
  
  protected
  
  # Returns true or false if the <%= file_name %> is logged in.
  # Preloads @current_<%= file_name %> with the <%= file_name %> model if they're logged in.
  def logged_in?
    !!current_<%= file_name %>
  end

  # Accesses the current <%= file_name %> from the session.
  # Future calls avoid the database because nil is not equal to false.
  def current_<%= file_name %>
    @current_<%= file_name %> ||= login_via_authenticator unless @current_<%= file_name %> == false
  end

  # Store the given <%= file_name %> id in the session.
  def current_<%= file_name %>=(new_<%= file_name %>)
    session[:<%= file_name %>_id] = new_<%= file_name %> ? new_<%= file_name %>.id : nil
    @current_<%= file_name %> = new_<%= file_name %> || false
  end

  # Check if the <%= file_name %> is authorized
  #
  # Override this method in your controllers if you want to restrict access
  # to only a few actions or if you want to check if the <%= file_name %>
  # has the correct rights.
  #
  # Example:
  #
  #  # only allow nonbobs
  #  def authorized?
  #    current_<%= file_name %>.login != "bob"
  #  end
  #
  def authorized?(action=nil, resource=nil, *args)
    logged_in?
  end

  # Filter method to enforce a login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :login_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :login_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  #
  def login_required
    authorized? || access_denied
  end
  
  ##MySTuff
  
  #login via an authorization, if that works and there is an account, pass it up 
  #or return nil
  def login_via_authenticator
    (authorized = login && authorized.account) || nil
  end

  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the <%= file_name %> is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    respond_to do |format|
      format.html do
        store_location
        redirect_to new_<%= controller_routing_name %>path
      end
      # format.any doesn't work in rails version < http://dev.rubyonrails.org/changeset/8987
      # you may want to change format.any to e.g. format.any(:js, :xml)
      format.any do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.request_uri
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.  Set an appropriately modified
  #   after_filter :store_location, :only => [:index, :new, :show, :edit]
  # for any controller you want to be bounce-backable.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  
  # Inclusion hook to make #current_<%= file_name %> and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)  
    base.send :helper_method, :current_<%= file_name %>, :logged_in?, :authorized? if base.respond_to? :helper_method
  end
  #
  # Login
  #
  
   

  # This is ususally what you want; resetting the session willy-nilly wreaks
  # havoc with forgery protection, and is only strictly necessary on login.
  # However, **all session state variables should be unset here**.
  def logout_keeping_session!
    # Kill server-side auth cookie
    @current_<%= file_name %>.forget_me if @current_<%= file_name %>.is_a? <%= class_name %>
    @current_<%= file_name %> = false     # not logged in, and don't do it for me
    kill_remember_cookie!     # Kill client-side auth cookie
    session[:<%= file_name %>_id] = nil   # keeps the session but kill our variable
    # explicitly kill any other session variables you set
  end

  # The session should only be reset at the tail end of a form POST --
  # otherwise the request forgery protection fails. It's only really necessary
  # when you cross quarantine (logged-out to logged-in).
  def logout_killing_session!
    logout_keeping_session!
    reset_session
  end
  
  #
  # Remember_me Tokens
  #
  # Cookies shouldn't be allowed to persist past their freshness date,
  # and they should be changed at each login

  # Cookies shouldn't be allowed to persist past their freshness date,
  # and they should be changed at each login

  def valid_remember_cookie?
    return nil unless @current_<%= file_name %>
    (@current_<%= file_name %>.remember_token?) && 
      (cookies[:auth_token] == @current_<%= file_name %>.remember_token)
  end
  
  # Refresh the cookie auth token if it exists, create it otherwise
  def handle_remember_cookie! new_cookie_flag
    return unless @current_<%= file_name %>
    case
    when valid_remember_cookie? then @current_<%= file_name %>.refresh_token # keeping same expiry date
    when new_cookie_flag        then @current_<%= file_name %>.remember_me 
    else                             @current_<%= file_name %>.forget_me
    end
    send_remember_cookie!
  end

  def kill_remember_cookie!
    cookies.delete :auth_token
  end
  
  def send_remember_cookie!
    cookies[:auth_token] = {
      :value   => @current_<%= file_name %>.remember_token,
      :expires => @current_<%= file_name %>.remember_token_expires_at }
  end
  
end