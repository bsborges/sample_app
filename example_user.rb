class User
  attr_accessor :name, :email

  def initialize(attributes = {name: 'default_name', email:'default_email'})
    @name  = attributes[:name]
    @email = attributes[:email]
  end

  def formatted_email
    "#{@name} <#{@email}>"
  end
end