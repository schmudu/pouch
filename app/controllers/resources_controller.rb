class ResourcesController < ApplicationController
  include ResourcesHelper
  helper :resources
  before_filter :authenticate_user!, :only => [:new, :download, :create]
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
    logger.debug("\n\n====before: attribute count: #{params[:resource][:attachments_attributes].nil?}")
    #clear nil attachments
    unless params[:resource][:attachments_attributes].nil?
    logger.debug("====attribute count: #{params[:resource][:attachments_attributes].count}")
      params[:resource][:attachments_attributes].each do |key, attribute|
        #logger.debug("\n\nLISTING RESOURCE: destroy: #{attribute[:_destroy]} file.nil?: #{attribute[:file].kind_of?(NilClass)} file_cache.nil?:#{attribute[:file_cache].kind_of?(NilClass)} destroy:#{attribute[:_destroy]} falseClass:#{attribute[:_destroy] == 'false'}")
        logger.debug("====LISTING RESOURCE: destroy: #{attribute[:_destroy]} file.nil?: #{attribute[:file].kind_of?(NilClass)} file.empty? #{attribute[:file] == ''} file_cache.nil?:#{attribute[:file_cache].kind_of?(NilClass)}")

        #clear out attachments where the file and file_cache is empty(or nil) or destroy is not false
        if((attribute[:_destroy] != 'false') || (((attribute[:file].kind_of?(NilClass)) || (attribute[:file] == '')) && ((attribute[:file_cache].kind_of?(NilClass)) || (attribute[:file_cache] == ''))))
          logger.debug("\n\nDELETING RESOURCE: key: #{key} cache:#{attribute[:file_cache]}")
          params[:resource][:attachments_attributes].delete(key)
        end
      end

      @resource = Resource.new(params[:resource])
      @resource.user_id = current_user.id
      logger.debug("====OUTPUT: attachments: #{params[:resource][:attachments_attributes].empty?}")
      if params[:resource][:attachments_attributes].empty?
        @resource.valid?
        @resource.errors[:attachments] = 'Must provide at least one attachment'
        render 'new'
      elsif @resource.save
        redirect_to @resource, notice: 'Resource was successfully created.' 
      else
        render 'new'
      end
    else
      @resource = Resource.new(params[:resource])
      @resource.user_id = current_user.id

      #no attachments, validate for any other errors 
      @resource.valid?
      @resource.errors[:attachments] = 'Must provide at least one attachment'
      render 'new'
    end
  end

  # PUT /resources/1
  # PUT /resources/1.json
  def update
#clear nil attachments
    @resource = Resource.find(params[:id])
=begin
    logger.debug("\n\n\n==DEBUG: update called!\n")
    @resource = Resource.find(params[:id])
    unless params[:resource][:attachments_attributes].nil?
      params[:resource][:attachments_attributes].each do |key, attribute|
        #logger.debug("\n\nLISTING RESOURCE: destroy: #{attribute[:_destroy]} file.nil?: #{attribute[:file].kind_of?(NilClass)} file_cache.nil?:#{attribute[:file_cache].kind_of?(NilClass)} destroy:#{attribute[:_destroy]} falseClass:#{attribute[:_destroy] == 'false'}")
        logger.debug("\n\nLISTING RESOURCE: destroy: #{attribute[:_destroy]} file.nil?: #{attribute[:file].kind_of?(NilClass)} file_cache.nil?:#{attribute[:file_cache].kind_of?(NilClass)}")

        #clear out attachments where the file and file_cache is empty(or nil)
        if(((attribute[:file].kind_of?(NilClass)) || (attribute[:file] == '')) && ((attribute[:file_cache].kind_of?(NilClass)) || (attribute[:file_cache] == '')))
          logger.debug("\n\nDELETING RESOURCE: key: #{key} cache:#{attribute[:file_cache]}")
          params[:resource][:attachments_attributes].delete(key)
        end
        if((attribute[:_destroy] != 'false') || (((attribute[:file].kind_of?(NilClass)) || (attribute[:file] == '')) && ((attribute[:file_cache].kind_of?(NilClass)) || (attribute[:file_cache] == ''))))
          logger.debug("\n\nDELETING RESOURCE: key: #{key} cache:#{attribute[:file_cache]}")
          params[:resource][:attachments_attributes].delete(key)
        end
      end
      
      
      #@resource = Resource.new(params[:resource])
      #@resource.user_id = current_user.id
      logger.debug("===OUTPUT: before descriptiont: #{params[:resource][:description].empty?}")
      @resource.update_attributes(params[:resource])
      logger.debug("===OUTPUT: after resource description: #{@resource.description}")
      if params[:resource][:attachments_attributes].empty?
        @resource.valid?
        @resource.errors[:attachments] = 'Must provide at least one attachment'
        render 'edit'
      elsif @resource.update_attributes(params[:resource])
        redirect_to @resource, notice: 'Resource was successfully updated.' 
      else
        render 'edit'
      end
    else
      #@resource = Resource.new(params[:resource])
      #@resource.user_id = current_user.id

      #no attachments, validate for any other errors 
      @resource.update_attributes(params[:resource])
      @resource.valid?
      @resource.errors[:attachments] = 'Must provide at least one attachment'
      render 'edit'
    end
=end
    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { head :no_content }
      else
        @resource.errors.each do |key, error|
          logger.debug("==DEBUG KEY: #{key} ERROR: #{error}\n")
        end

        #format.html { render :text => "tried to update attributes but failed."}
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
