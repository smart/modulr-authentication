class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table "<%= table_name %>", :force => true do |t|
      t.timestamps
<% if options[:include_activation] -%>
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime<% end %>
<% if options[:stateful] -%>
      t.column :state,                     :string, :null => :no, :default => 'passive'
      t.column :deleted_at,                :datetime<% end %>
    end
    add_index :<%= table_name %>, :login, :unique => true
  end

  def self.down
    drop_table "<%= table_name %>"
  end
end
