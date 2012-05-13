class ResourcesController < ApplicationController
  include ResourcesHelper
  helper :resources
  before_filter :authenticate_user!, :only => [:new, :download, :create, :edit, :destroy, :update]
  before_filter :is_resource_owner?, :only => [:edit, :destroy, :update]

  def download_cached_attachment 
    path = "tmp/cache/#{params[:id]}/#{params[:basename]}.#{params[:extension]}"
    send_file path, :x_sendfile=>true
  end

  def download
    #update user count
    current_user.update_attribute(:downloads, current_user.downloads + 1)

    #update attachment download
    attachment = Attachment.find_by_id(params[:id])
    attachment.update_attribute(:downloads, attachment.downloads + 1)

    #create new user_attachment_download
    UserAttachmentDownload.create(:user_id => current_user.id, :attachment_id => attachment.id)
    path = "uploads/#{params[:id]}/#{params[:basename]}.#{params[:extension]}"
    send_file path, :x_sendfile=>true
  end

  # GET /resources
  # GET /resources.json
  def index

    @resources = Resource.search(params)

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
    #clear nil attachments
    unless params[:resource][:attachments_attributes].nil?
      params[:resource][:attachments_attributes].each do |key, attribute|
        #clear out attachments where the file and file_cache is empty(or nil) or destroy is not false
        if((attribute[:_destroy] != 'false') || (((attribute[:file].kind_of?(NilClass)) || (attribute[:file] == '')) && ((attribute[:file_cache].kind_of?(NilClass)) || (attribute[:file_cache] == ''))))
          logger.debug("\n\nDELETING RESOURCE: key: #{key} cache:#{attribute[:file_cache]}")
          params[:resource][:attachments_attributes].delete(key)
        end
      end
    end
      @resource = Resource.new(params[:resource])
      @resource.user_id = current_user.id
      @resource.valid?

      @resource.errors[:agreed] = 'Must agree to terms of use.' unless @resource.agreed == '1'
      if((params[:resource][:attachments_attributes].nil?) || (params[:resource][:attachments_attributes].empty?))
        @resource.errors[:attachments] = 'Must provide at least one attachment'
        render 'new'
      elsif !@resource.errors.empty?
        render 'new'
      elsif @resource.save
        redirect_to @resource, notice: 'Resource was successfully created.' 
      else
        render 'new'
      end
=begin
    else
      @resource = Resource.new(params[:resource])
      @resource.user_id = current_user.id
      @resource.valid?

      #check terms of use
      @resource.errors[:agreed] = 'Must agree to terms of use.' unless @resource.agreed == '1'

      @resource.errors[:attachments] = 'Must provide at least one attachment'
      render 'new'
    end
=end
  end

  # PUT /resources/1
  # PUT /resources/1.json
  def update
    #clear nil attachments
    @resource = Resource.find(params[:id])
    counter = @resource.attachments.count   #track number of attachments resource will have if we update it
    resource_changed = false                #track whether or not resource has changed

    params[:resource][:attachments_attributes].each do |key, attribute|
      #control structure created because we can't validate the model
      #sum the number of potential attachments that the resource will have
      if(attribute[:_destroy] == 'false')
        if((attribute[:id].kind_of?(NilClass)) && (attribute[:file].nil?))
          #clear out attachments where no file was referenced
          params[:resource][:attachments_attributes].delete(key)
        elsif(attribute[:id].nil?)
          #uploading new file
          counter += 1
          resource_changed = true
        else
          #file untouched, previously loaded
        end
      else
        if(!attribute[:file].nil?)
          #delete files that were uploaded, but were removed
          params[:resource][:attachments_attributes].delete(key)
        elsif(!attribute[:id].nil?)
          #file previously uploaded and will be removed
          counter += -1
          resource_changed = true
        else
          #empty file was added and removed
        end
      end
    end

    #check if title/description have changed
    resource_changed = true if((params[:resource][:title] != @resource.title) || (params[:resource][:description] != @resource.description))

    #TODO: going to need to check for tags and grade level changes
    
    if(counter<ConstantsHelper::RESOURCE_ATTACHMENTS_MIN_NUM)
      #counter needs to have at least one attachment
      @resource.valid?
      @resource.errors[:attachments] = 'Must provide at least one attachment'
      render 'edit'
    elsif @resource.update_attributes(params[:resource])
      resource_changed ? notice = t('resources.updated') : notice = t('resources.no_change')
      redirect_to @resource, notice: notice
    else
      @resource.errors.each do |key, error|
        logger.debug("==DEBUG KEY: #{key} ERROR: #{error}\n")
      end
      render 'edit'
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

  private

  def is_resource_owner?
    @resource = Resource.find(params[:id])
    redirect_to :controller=>'pages', :action => 'unauthorized' if(@resource.user_id != current_user.id)
  end
end
