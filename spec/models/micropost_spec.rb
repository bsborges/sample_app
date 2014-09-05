require 'spec_helper'

# describe Micropost do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

# results in:

# Pending:
#   Micropost add some examples to (or delete) /home/ubuntu/workspace/rails_4_tutorial/sample_app/spec/models/micropost_spec.rb
      # No reason given
      # ./spec/models/micropost_spec.rb:4
      
describe Micropost do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }
  # This pattern is the canonical way to make a micropost: through its association
  # with a user. When a new micropost is made in this way, its user_id is 
  # automatically set to the right value

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  
  it { should be_valid }

  # no associated user?
  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end
  
  # content attribute must be present
  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  # content must be constrained to be no longer than 140 characters
  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
  
end