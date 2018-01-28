<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
<% attributes.select(&:reference?).each do |attribute| -%>
belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', required: true' if attribute.required? %>
<% end -%>
<% if attributes.any?(&:password_digest?) -%>
has_secure_password
<% end -%>

# ------------------- References ------------------------

# 	belongs_to :user
	
# 	has_many  :supervisor, :foreign_key => 'contact_id'

# -------------------------------------------------------

# ********* It is assumed an attribute called 'name' exists for most models.  Adjust or comment accordingly ************************  

  validates :name, presence: true, uniqueness: {case_sensitive: false}, length:  { maximum: 200 }
  
	def self.default_scope
			# this notation prevents ambiguity	
      order(name: :asc)  	
      # http://stackoverflow.com/questions/16896937/rails-activerecord-pgerror-error-column-reference-created-at-is-ambiguous
	end

# ***********************************************************************************************************************************                     

end

<% end -%>