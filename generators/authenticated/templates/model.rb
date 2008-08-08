require 'digest/sha1'

class <%= class_name %> < ActiveRecord::Base
<% if options[:aasm] -%>
  include Authorization::AasmRoles
<% elsif options[:stateful] -%>
  include Authorization::StatefulRoles<% end %>

  <% if options[:include_activation] && !options[:stateful] %>before_create :make_activation_code <% end %>



<% if options[:include_activation] && !options[:stateful] %>
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end<% end %>

  protected
    
<% if options[:include_activation] -%>
    def make_activation_code
  <% if options[:stateful] -%>
      self.deleted_at = nil
  <% end -%>
      self.activation_code = self.class.make_token
    end
<% end %>

end
