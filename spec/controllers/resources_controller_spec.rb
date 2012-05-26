require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ResourcesController do
  include Devise::TestHelpers
  include ResourcesHelper
  include ConstantsHelper
  render_views
 
  def valid_session
    {}
  end 

  before(:each) do
    @another_user = FactoryGirl.create(:user, :email => 'abc@abc.com', :screen_name => 'toad', :password => 'abC123', :password_confirmation => 'abC123')
    @another_user.confirm!
  end

  describe "GET download" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @user.confirm!

      @resource = FactoryGirl.create(:resource, :user_id => @user.id)
    end

    it "should redirect to sign in page if user not signed in" do
      attachment = @resource.attachments.first
      file_info = get_file_info attachment.file.path
      get :download, {:id => file_info[:folder], :basename => file_info[:base_name], :extension => file_info[:extension]}
      response.should redirect_to(new_user_session_path)
    end

    it "should be success if user is signed in" do
      sign_in @user

      attachment = @resource.attachments.first
      file_info = get_file_info attachment.file.path
      get :download, {:id => file_info[:folder], :basename => file_info[:base_name], :extension => file_info[:extension]}
      response.should be_success
    end

    it "should increment user download count after success" do
      sign_in @user

      #before
      user = User.find_by_email(@user.email)
      user.downloads.should == 0

      attachment = @resource.attachments.first
      file_info = get_file_info attachment.file.path
      get :download, {:id => file_info[:folder], :basename => file_info[:base_name], :extension => file_info[:extension]}

      #after
      user = User.find_by_email(@user.email)
      user.downloads.should == 1
    end

    it "should increment attachment download count after success" do
      sign_in @user

      #before
      attachment = Attachment.find_by_id(@resource.attachments.first.id)
      attachment.downloads.should == 0

      file_info = get_file_info attachment.file.path
      get :download, {:id => file_info[:folder], :basename => file_info[:base_name], :extension => file_info[:extension]}

      #after
      attachment = Attachment.find_by_id(@resource.attachments.first.id)
      attachment.downloads.should == 1
    end

    it "should increment attachment download count after success for user and attachment" do
      sign_in @user

      #before
      user = User.find_by_email(@user.email)
      user.user_attachment_downloads.length.should == 0
      attachment = Attachment.find_by_id(@resource.attachments.first.id)
      attachment.user_attachment_downloads.length.should == 0

      file_info = get_file_info attachment.file.path
      get :download, {:id => file_info[:folder], :basename => file_info[:base_name], :extension => file_info[:extension]}

      #after
      user = User.find_by_email(@user.email)
      user.user_attachment_downloads.length.should == 1
      attachment = Attachment.find_by_id(@resource.attachments.first.id)
      attachment.user_attachment_downloads.length.should == 1
    end
  end

  describe "GET show" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @user.confirm!
      @resource = FactoryGirl.create(:resource, :user_id => @user.id)
    end

    it "assigns the requested resource as @resource" do
      get :show, {:id => @resource.id}
      response.should be_success
    end

    it "should redirect to lost page if resource not found" do
      get :show, {:id => -928938293892}
      response.should redirect_to(lost_path)
    end

    it "should increment user_resource view count after success for user and resource" do
      sign_in @user

      #before
      user = User.find_by_email(@user.email)
      user.user_resource_views.length.should == 0
      resource = Resource.find_by_id(@resource.id)
      resource.user_resource_views.length.should == 0

      get :show, {:id => @resource.id}

      #after
      user = User.find_by_email(@user.email)
      user.user_resource_views.length.should == 1
      resource = Resource.find_by_id(@resource.id)
      resource.user_resource_views.length.should == 1
    end

    it "should increment user_resource view count after success for nil and resource even if no one is signed in" do
      #before
      resource = Resource.find_by_id(@resource.id)
      resource.user_resource_views.length.should == 0

      get :show, {:id => @resource.id}

      #after
      resource = Resource.find_by_id(@resource.id)
      resource.user_resource_views.length.should == 1

      user_resource_view = UserResourceView.first
      user_resource_view.user_id.should be_nil
    end

    it "should increment view count" do
      #before
      resource = Resource.find_by_id(@resource.id)
      resource.views.should == 0

      get :show, {:id => @resource.id}
      get :show, {:id => @resource.id}

      #after
      resource = Resource.find_by_id(@resource.id)
      resource.views.should == 2
    end
  end

  describe "GET new" do
    it "should redirect to sign in page" do
      get :new
      response.should redirect_to(new_user_session_path)
    end

    it "after login should go to page" do
      login_user
      get :new
      response.should have_selector('body', :content => 'New resource')
    end
  end

  describe "POST create" do
    before(:each) do
      login_user
    end

    def valid_attributes params
      {:title => "My worksheet", :description => "My first worksheet for 1st grade", :agreed => "1", :attachments_attributes => params}
        #{:one => attributes_uploaded_file}
      #}
    end

    def empty_file
     {} 
    end

    def removed_file
     {:file => Rack::Test::UploadedFile.new(TEST_FILE_PATH, 'txt'), :_destroy=>"1"} 
    end

    def uploaded_file
     {:file => Rack::Test::UploadedFile.new(TEST_FILE_PATH, 'txt'), :_destroy=>"false"} 
    end

    describe "user not signed in" do
      before(:each) do
        logout_user
      end

      it "should redirect to sign in page" do
        post :create, {:resource => valid_attributes(:one => uploaded_file)}, valid_session
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "with valid params" do
      it "creates a new Resource with one attachment" do
        lambda do
          post :create, {:resource => valid_attributes({:one => uploaded_file})}
          resource = Resource.last
          response.should redirect_to(resource_path(:id => resource.id))
        end.should change(Resource, :count).by(1)
      end

      it "creates a new Resource with three attachments" do
        lambda do
          post :create, {:resource => valid_attributes({:one => uploaded_file, :two => uploaded_file, :three => uploaded_file})}
        end.should change(Resource, :count).by(1)
        resource = Resource.last
        resource.attachments.count.should == 3
      end

      it "creates a new Resource with two attachment, one removed, and one empty" do
        lambda do
          post :create, {:resource => valid_attributes({:one => empty_file, :two => removed_file, :three => uploaded_file, :four => uploaded_file})}
        end.should change(Resource, :count).by(1)
        resource = Resource.last
        resource.attachments.count.should == 2
      end
    end

    describe "with invalid params" do
      it "should re-render new page if agreed is not set" do
        lambda do
          post :create, {:resource => valid_attributes({:one => uploaded_file}).merge({:agreed => 0})}
          resource = Resource.last
          response.should render_template('new')
        end.should_not change(Resource, :count)
      end
      
      it "should re-render new page with empty attributes file" do
        lambda do
          post :create, {:resource => valid_attributes({:one => empty_file})}
          response.should render_template('new')
        end.should_not change(Resource, :count)
      end

      it "should re-render template new with removed attributes file" do
        lambda do
          post :create, {:resource => valid_attributes({:one => removed_file})}
          response.should render_template('new')
        end.should_not change(Resource, :count)
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      login_user

      #attach two documents
      @attachment_one = FactoryGirl.create(:attachment)
      @attachment_two = FactoryGirl.create(:attachment)
      @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one, @attachment_two])
    end

    def valid_attributes params
      {:title => "My worksheet", :description => "My first worksheet for 1st grade", :attachments_attributes => params}
    end

    def file_previously_uploaded_untouched attachment_id
     {:file_cache => '', :_destroy=>"false", :id=>"#{attachment_id}"} 
    end

    def file_empty_added
     {:file_cache => "", :_destroy=>"false"} 
    end

    def file_empty_added_removed
     {:file_cache => "", :_destroy=>"1"} 
    end

    def file_uploaded
     {:file => Rack::Test::UploadedFile.new(TEST_FILE_PATH, 'txt'), :_destroy=>"false"} 
    end

    def file_previously_uploaded_removed attachment_id
     {:file_cache => "", :_destroy=>"1", :id=>"#{attachment_id}"} 
    end

    def file_uploaded_removed
     {:file => Rack::Test::UploadedFile.new(TEST_FILE_PATH, 'txt'), :_destroy=>"1"} 
    end

    it "should not allow anyone to update resources if not signed in" do
      sign_out @user
      post :update, {:id=>@resource.id, :resource => valid_attributes({:one => file_previously_uploaded_untouched(@attachment_one.id), :two => file_previously_uploaded_untouched(@attachment_two.id)})}
      response.should redirect_to(new_user_session_path)
    end 

    describe "with valid params" do
      it "updates resource with no changes" do
        lambda do
          post :update, {:id=>@resource.id, :resource => valid_attributes({:one => file_previously_uploaded_untouched(@attachment_one.id), :two => file_previously_uploaded_untouched(@attachment_two.id)})}
          response.should redirect_to(resource_path(:id => @resource.id))
        end.should_not change(@resource.attachments, :count)
      end

      it "updates resource with two empty files" do
        lambda do
          post :update, {:id=>@resource.id, :resource => valid_attributes({:one => file_previously_uploaded_untouched(@attachment_one.id), :two => file_previously_uploaded_untouched(@attachment_two.id), :three => file_empty_added, :four => file_empty_added})}
          response.should redirect_to(resource_path(:id => @resource.id))
        end.should_not change(@resource.attachments, :count)
      end

      it "updates resource with and removes one file" do
        lambda do
          post :update, {:id=>@resource.id, :resource => valid_attributes({:one => file_previously_uploaded_untouched(@attachment_one.id), :two => file_previously_uploaded_removed(@attachment_two.id)})}
          response.should redirect_to(resource_path(:id => @resource.id))
        end.should change(@resource.attachments, :count).from(2).to(1)
      end

      it "updates resource with uploaded file but then removes it" do
        lambda do
          post :update, {:id=>@resource.id, :resource => valid_attributes({:one => file_previously_uploaded_untouched(@attachment_one.id), :two => file_previously_uploaded_untouched(@attachment_two.id), :three => file_uploaded_removed})}
          response.should redirect_to(resource_path(:id => @resource.id))
        end.should_not change(@resource.attachments, :count)
      end

      it "updates resource with an empty file added/removed" do
        lambda do
          post :update, {:id=>@resource.id, :resource => valid_attributes({:one => file_previously_uploaded_untouched(@attachment_one.id), :two => file_previously_uploaded_untouched(@attachment_two.id), :three => file_empty_added_removed})}
          response.should redirect_to(resource_path(:id => @resource.id))
        end.should_not change(@resource.attachments, :count)
      end

      it "updates resource with two additional files" do
        lambda do
          post :update, {:id=>@resource.id, :resource => valid_attributes({:one => file_previously_uploaded_untouched(@attachment_one.id), :two => file_previously_uploaded_untouched(@attachment_two.id), :three => file_uploaded, :four =>file_uploaded})}
          response.should redirect_to(resource_path(:id => @resource.id))
        end.should change(@resource.attachments, :count).from(2).to(4)
      end
    end

    describe "with invalid params" do
      it "attempts to update resource by removing all attachments" do
          post :update, {:id=>@resource.id, :resource => valid_attributes({:one => file_previously_uploaded_removed(@attachment_one.id), :two => file_previously_uploaded_removed(@attachment_two.id)})}
          response.should render_template('edit')
      end

      it "another user tries to edit a resource they do not own" do
        sign_out @user
        sign_in @another_user
        post :update, {:id=>@resource.id, :resource => valid_attributes({:one => file_previously_uploaded_removed(@attachment_one.id), :two => file_previously_uploaded_removed(@attachment_two.id)})}
        response.should redirect_to(unauthorized_path)
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      login_user

      #attach two documents
      @attachment_one = FactoryGirl.create(:attachment)
      @attachment_two = FactoryGirl.create(:attachment)
      @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one, @attachment_two])
    end

    it "should not allow anyone to delete resources if not signed in" do
      sign_out @user
      delete :destroy, {:id => @resource.to_param}
      response.should redirect_to(new_user_session_path)
    end

    it "should delete resource if destroy method called" do
      lambda do
        delete :destroy, {:id => @resource.to_param}
      end.should change(Resource, :count).by(-1)
    end

    it "another user tries to edit a resource they do not own" do
      sign_out @user
      sign_in @another_user
      delete :destroy, {:id => @resource.to_param}
      response.should redirect_to(unauthorized_path)
    end
  end

  describe "GET edit" do
    before(:each) do
        login_user
        #attach two documents
        @attachment_one = FactoryGirl.create(:attachment)
        @attachment_two = FactoryGirl.create(:attachment)
        @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one, @attachment_two])
    end

    it "should not allow anyone to delete resources if not signed in" do
      sign_out @user
      get :edit, {:id => @resource.to_param}
      response.should redirect_to(new_user_session_path)
    end 

    it "render template edit if user is signed in" do
      get :edit, {:id => @resource.to_param}
      response.should render_template('edit')
    end 

    it "another user tries to edit a resource they do not own" do
      sign_out @user
      sign_in @another_user
      get :edit, {:id => @resource.to_param}
      response.should redirect_to(unauthorized_path)
    end
  end

  describe "search" do
    after(:all) do
      Resource.tire.index.delete
    end

    before(:all) do
      Resource.index_name("test_#{Resource.model_name.plural}")
    end

    before(:each) do
      Resource.tire.index.delete
      Resource.tire.create_elasticsearch_index
      @user = FactoryGirl.create(:user)
      @user.confirm!
      attachment_one = FactoryGirl.create(:attachment)
      attachment_two = FactoryGirl.create(:attachment)
      resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [attachment_one, attachment_two])
      resource = FactoryGirl.create(:resource, :title => 'Patrick Random Worksheet', :user_id => @user.id, :attachments => [attachment_one, attachment_two])
      Resource.index.refresh
    end

    def params
      {:query => "random"}
    end

    it "should return an array of resources" do
      search = Resource.tire.search(params)
      puts "\n\n===count: #{search.results.count} resources: #{search}\n"
      puts "search: #{search.to_json}"
      #puts "===resource: #{resources.first} title: #{resources.first.title} description: #{resources.first.description}"
      search.results.should_not be_empty
    end

    it "should increase the number of queries by 1" do
      lambda do
        search = Resource.tire.search(params)
      end.should change(UserQuery, :count).from(0).to(1)
    end

    it "should not increase the number of queries if query is empty string" do
      lambda do
        search = Resource.tire.search({:query => ""})
      end.should_not change(UserQuery, :count)
    end
=begin
    it "should return a result even if not an exact match" do
      search = Resource.tire.search({:query => 'ran'})
      puts "\n\n===count: #{search.results.count} resources: #{search}\n"
      puts "search: #{search.to_json}"
      #puts "===resource: #{resources.first} title: #{resources.first.title} description: #{resources.first.description}"
      search.results.should_not be_empty
    end
=end
  end
=begin
  # This should return the minimal set of attributes required to create a valid
  # Resource. As you add validations to Resource, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ResourcesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all resources as @resources" do
      resource = Resource.create! valid_attributes
      get :index, {}, valid_session
      assigns(:resources).should eq([resource])
    end
  end
=end
end
