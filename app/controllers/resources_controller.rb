class ResourcesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :download]
  
  def download
    #update user count
    current_user.update_attribute(:downloads, current_user.downloads + 1)

    #note: attachment count is updated via the file_uploader.rb

    #create new user_attachment_download
    attachment = Attachment.find_by_id(params[:id])
    UserAttachmentDownload.create(:user_id => current_user.id, :attachment_id => attachment.id)
    path = "uploads/#{params[:id]}/#{params[:basename]}.#{params[:extension]}"
    send_file path, :x_sendfile=>true
  end

  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resources }
    end
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
    @resource = Resource.find(params[:id])

    #update view count
    @resource.update_attribute(:views, @resource.views + 1)

    #update user resource view count
    if user_signed_in?
      UserResourceView.create(:user_id => current_user.id, :resource_id => @resource.id) 
    else
      UserResourceView.create(:user_id => nil, :resource_id => @resource.id)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/new
  # GET /resources/new.json
  def new
    @resource = Resource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
  end

  # POST /resources
  # POST /resources.json
  def create
    @resource = Resource.new(params[:resource])
    @resource.user_id = current_user.id

    unless params[:resource][:attachments_attributes][0].nil?
      logger.debug("\n\nparams: #{params[:resource][:attachments_attributes][0][:file_cache]}")
    end
    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: 'Resource was successfully created.' }
        format.json { render json: @resource, status: :created, location: @resource }
      else
        @resource.errors.each do |e|
        end
        format.html { render action: "new" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.json
  def update
    @resource = Resource.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :no_content }
    end
  end
end
