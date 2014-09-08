require 'spec_helper'

describe "Static pages" do

  subject { page }
  
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
    
    # A test for rendering the feed on the Home page
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      
      # Testing the following/follower statistics on the Home page.
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
      
      # tests for the sidebar micropost counts (including proper pluralization)
      it { should have_selector('section h1', text: user.name) }
    #  it { pluralize(1, "micropost").should == "1 micropost" }
     # it { pluralize(0, "micropost").should == "0 microposts" }
      it "should show the total feeds" do
        # expect(page).to have_content("micropost".pluralize(user.feed.count))
        expect(page).to have_selector("section span", text: "micropost".pluralize(user.feed.count))
      end
      
      describe "micropost pagination" do
        
        it "should paginate the feed" do
          30.times { FactoryGirl.create(:micropost, user: user, content: "Consectetur adipiscing elit") }
          visit root_path
          page.should have_selector("div.pagination")
        end
      end
      
    end
    
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end
  
  describe "About page" do
    before { visit about_path }
    
    let(:heading)    { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end
  
  describe "Contact page" do
    before { visit contact_path }
    
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    expect(page).to have_title(full_title(''))
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    expect(page).to have_title(full_title(''))
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

end