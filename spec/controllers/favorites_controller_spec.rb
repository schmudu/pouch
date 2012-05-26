require 'spec_helper'

describe FavoritesController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    sign_in @user

    @attachment_one = FactoryGirl.create(:attachment)
    @resource = FactoryGirl.create(:resource, :user_id => @user.id, :attachments => [@attachment_one])
  end

  def valid_params_create
    {:resource_id => @resource.id}
  end

  describe "GET 'create'" do
    it "returns http success" do
      get :create
      response.should be_success
    end

    it "should increase count of Favorites by 1" do
      lambda do
        get :create, valid_params_create
      end.should change(Favorite, :count).from(0).to(1)
    end

    it "on sign out should redirect user to sign in page" do
      sign_out @user
      get :create, valid_params_create
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'destroy'" do
    before(:each) do
      @favorite = FactoryGirl.create(:favorite, :user_id => @user.id, :resource_id => @resource.id)
    end

    it "should decrease count of Favorites by 1" do
      lambda do
        get :destroy, {:id => @favorite.id}
      end.should change(Favorite, :count).from(1).to(0)
    end

    it "on sign out should redirect user to sign in page" do
      sign_out @user
      get :destroy, {:id => @favorite.id}
      response.should redirect_to(new_user_session_path)
    end
  end

end
