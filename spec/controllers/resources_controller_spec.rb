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

=begin
    it "should increment user download count after success" do
      login_user
      get :download
      response.should be_success
    end
=end
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
      {:title => "My worksheet", :description => "My first worksheet for 1st grade", :attachments_attributes => params}
        #{:one => attributes_uploaded_file}
      #}
    end

    def attributes_empty_file
     {} 
    end

    def attributes_removed_file
     {:file => Rack::Test::UploadedFile.new(TEST_FILE_PATH, 'txt'), :_destroy=>"1"} 
    end

    def attributes_uploaded_file
     {:file => Rack::Test::UploadedFile.new(TEST_FILE_PATH, 'txt'), :_destroy=>"false"} 
    end

    def valid_session
      {}
    end

    describe "user not signed in" do
      before(:each) do
        logout_user
      end

      it "should redirect to sign in page" do
        post :create, {:resource => valid_attributes(:one => attributes_uploaded_file)}, valid_session
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "with valid params" do
      it "creates a new Resource" do
        lambda do
          post :create, {:resource => valid_attributes({:one => attributes_uploaded_file})}
          resource = Resource.last
          response.should redirect_to(resource_path(:id => resource.id))
        end.should change(Resource, :count).by(1)
      end

      it "creates a new Resource with three attachments" do
        lambda do
          post :create, {:resource => valid_attributes({:one => attributes_uploaded_file, :two => attributes_uploaded_file, :three => attributes_uploaded_file})}
        end.should change(Resource, :count).by(1)
        resource = Resource.last
        resource.attachments.count.should == 3
      end

      it "creates a new Resource with two attachment, one removed, and one empty" do
        lambda do
          post :create, {:resource => valid_attributes({:one => attributes_empty_file, :two => attributes_removed_file, :three => attributes_uploaded_file, :four => attributes_uploaded_file})}
        end.should change(Resource, :count).by(1)
        resource = Resource.last
        resource.attachments.count.should == 2
      end
    end

    describe "with invalid params" do
      it "should re-render new page with empty attributes file" do
        lambda do
          post :create, {:resource => valid_attributes({:one => attributes_empty_file})}
          response.should render_template('new')
        end.should_not change(Resource, :count)
      end

      it "should re-render template new with removed attributes file" do
        lambda do
          post :create, {:resource => valid_attributes({:one => attributes_removed_file})}
          response.should render_template('new')
        end.should_not change(Resource, :count)
      end
    end
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

  describe "GET show" do
    it "assigns the requested resource as @resource" do
      resource = Resource.create! valid_attributes
      get :show, {:id => resource.to_param}, valid_session
      assigns(:resource).should eq(resource)
    end
  end

  describe "GET edit" do
    it "assigns the requested resource as @resource" do
      resource = Resource.create! valid_attributes
      get :edit, {:id => resource.to_param}, valid_session
      assigns(:resource).should eq(resource)
    end
  end


  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested resource" do
        resource = Resource.create! valid_attributes
        # Assuming there are no other resources in the database, this
        # specifies that the Resource created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Resource.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => resource.to_param, :resource => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested resource as @resource" do
        resource = Resource.create! valid_attributes
        put :update, {:id => resource.to_param, :resource => valid_attributes}, valid_session
        assigns(:resource).should eq(resource)
      end

      it "redirects to the resource" do
        resource = Resource.create! valid_attributes
        put :update, {:id => resource.to_param, :resource => valid_attributes}, valid_session
        response.should redirect_to(resource)
      end
    end

    describe "with invalid params" do
      it "assigns the resource as @resource" do
        resource = Resource.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Resource.any_instance.stub(:save).and_return(false)
        put :update, {:id => resource.to_param, :resource => {}}, valid_session
        assigns(:resource).should eq(resource)
      end

      it "re-renders the 'edit' template" do
        resource = Resource.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Resource.any_instance.stub(:save).and_return(false)
        put :update, {:id => resource.to_param, :resource => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested resource" do
      resource = Resource.create! valid_attributes
      expect {
        delete :destroy, {:id => resource.to_param}, valid_session
      }.to change(Resource, :count).by(-1)
    end

    it "redirects to the resources list" do
      resource = Resource.create! valid_attributes
      delete :destroy, {:id => resource.to_param}, valid_session
      response.should redirect_to(resources_url)
    end
  end
=end
end
