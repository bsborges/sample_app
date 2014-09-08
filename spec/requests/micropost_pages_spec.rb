require 'spec_helper'

# describe "MicropostPages" do
#   describe "GET /micropost_pages" do
#     it "works! (now write some real specs)" do
#       # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#       get micropost_pages_index_path
#       response.status.should be(200)
#     end
#   end
# end

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
      
      # test to make sure delete links do not appear for microposts not created by the current user
      # TODO delete micropost should be an authorization issue and not a micropost issue -> authentication_pages_spec.rb
      describe "micropost destruction" do
        let!(:micropost) { FactoryGirl.create(:micropost, user: user) }
        let(:another_user) { FactoryGirl.create(:user) }
        before do
          sign_in another_user
          visit user_path(user)
        end
        
        it "should not have delete link of other users' microposts" do
          expect(page).to_not have_link('delete')
        end
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end