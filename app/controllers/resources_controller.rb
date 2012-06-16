require 'open-uri'

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
    #path = "uploads/#{params[:id]}/#{params[:basename]}.#{params[:extension]}"
    path = attachment.file_url
    send_file path, :x_sendfile=>true
  end

  # GET /resources
  # GET /resources.json
  def index
    logger.debug("\n\n====index: params: #{params}\n")

    @resources = Resource.search(params)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resources }
    end
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
    @resource = Resource.find_by_id(params[:id])

    unless @resource.nil?
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
    else
      redirect_to lost_path
    end
  end

  # GET /resources/new
  # GET /resources/new.json
  def new
    @resource = Resource.new
    @grades = Grade.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
    @grades = Grade.all
  end

  # POST /resources
  # POST /resources.json
  def create
    #any validation changes here may need to be duplicated in update method
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

      logger.debug "\n===contains grades: #{params_contains_grades? params}"
      #check for grade levels
      @resource.errors[:grades] = t('resources.no_grade') unless params_contains_grades? params
      @resource.errors[:agreed] = t('resources.agreement') unless @resource.agreed == '1'
      @resource.errors[:topics] = t('resources.no_topic') if @resource.topics.empty?
      
      if((params[:resource][:attachments_attributes].nil?) || (params[:resource][:attachments_attributes].empty?))
        @grades = Grade.all
        @resource.errors[:attachments] = 'Must provide at least one attachment'
      end

      if !@resource.errors.empty?
        @grades = Grade.all
        render 'new'
      else 
        #@resource.extract_content
        @resource.save
        # save resource_grades
        create_resource_grades(@resource, params)

        logger.debug "\n=====#{params['grade_1']} \n"
        redirect_to @resource, notice: 'Resource was successfully created.' 
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
    #any validation changes here may need to be duplicated in create method
    #clear nil attachments
    @resource = Resource.find(params[:id])
    counter = @resource.attachments.count   #track number of attachments resource will have if we update it
    resource_changed = false                #track whether or not resource has changed
    resource_attachment_changed = false     #track whether or not a file was add/removed

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
          resource_attachment_changed = true
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
          resource_attachment_changed = true
        else
          #empty file was added and removed
        end
      end
    end

   

    #check if at least one grade is submitted
    @potential_grades = params.select{|key, value| key =~ /grade_/}
    @resource.errors[:grades] = t('resources.no_grade') if @potential_grades.empty?

    #check if title/description have changed
    resource_changed = true if((params[:resource][:title] != @resource.title) || (params[:resource][:description] != @resource.description))

    #check for topic tags
    @resource.errors[:topics] = t('resources.no_topic') if params[:resource][:topic_tokens].empty?
    
    if(counter<ConstantsHelper::RESOURCE_ATTACHMENTS_MIN_NUM)
      #counter needs to have at least one attachment
      @resource.valid?
      @resource.errors[:attachments] = 'Must provide at least one attachment'
    end

    if !@resource.errors.empty?
      @grades = Grade.all
      render 'edit'
    elsif @resource.update_attributes(params[:resource])
      #update extracted content
      if resource_attachment_changed
        @resource.extract_content
        @resource.save
      end
      logger.debug("==start resource_grades_count: #{@resource.resource_grades.count}\n")
      #remove grade levels not checked
      @resource.resource_grades.each do |rg|
        if !params.include?("grade_#{rg.grade_id}")
          logger.debug("==destroying: #{rg.id}")
          rg.destroy
        end
      end

      #add grade levels checked
      logger.debug("\n==before: potential_grades(params)")
      @potential_grades.each do |key, value|
        logger.debug "======potential grade: #{key}\n"
      end
      logger.debug("\n==before: resource_grades")
      @resource.resource_grades.each do |rg|
        logger.debug "======grade: #{rg.grade_id}\n"
      end
      #@add_grades = @potential_grades.select{|key, value| @resource.resource_grades.each{|rg| rg.grade_id.to_s.chomp.eql?(key[(key.to_s =~ /\d/),key.to_s.length]).chomp}}
      @add_grades = @potential_grades.reject{|key, value| match_params(key, @resource)}
=begin
      @add_grades = @potential_grades.select do |key, value| 
        @resource.resource_grades.find_all do |rg|
          logger.debug "===testing: #{rg.grade_id.to_s.chomp} against key: #{(key[(key.to_s =~ /\d/),key.to_s.length]).chomp}"
          logger.debug "===final test: #{rg.grade_id.to_s.chomp.eql? (key[(key.to_s =~ /\d/),key.to_s.length]).to_s.chomp}"
          rg.grade_id.to_s.chomp.eql? (key[(key.to_s =~ /\d/),key.to_s.length]).chomp
        end
      end
=end
      #output this
      logger.debug("==after")
      @add_grades.each do |key, value|
        created_grade = ResourceGrade.create(:resource_id => @resource.id, :grade_id => key.extract_grade_id)
        logger.debug "======adding grade: #{key.extract_grade_id} success: #{created_grade.errors.first}\n"
      end

      #resource_changed ? notice = t('resources.updated') : notice = t('resources.no_change')
      notice = t('resources.saved')
      redirect_to @resource, notice: notice
    else
      @grades = Grade.all
      render 'edit'
    end
  end

  def match_params(key, resource)
    #return true false whether or not the resource has the key as a grade_id
    resource.resource_grades.find_all do |rg|
      #if rg.grade_id.to_s.chomp.eql? (key[(key.to_s =~ /\d/),key.to_s.length]).to_s.chomp     
      if rg.grade_id.to_s.chomp.eql? key.extract_grade_id    
        logger.debug "match\n"
        return true;
      else
        logger.debug "no match\n"
        return false;
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

  private

  def create_resource_grades(resource, params)
    Grade.all.each do |grade|
      if params.include?("grade_#{grade.id}")
        ResourceGrade.create(:resource_id => resource.id, :grade_id => grade.id)
      end
    end
  end

  def is_resource_owner?
    @resource = Resource.find(params[:id])
    redirect_to :controller=>'pages', :action => 'unauthorized' if(@resource.user_id != current_user.id)
  end

  def params_contains_grades? params
    Grade.all.each do |grade|
      return true if params.include?("grade_#{grade.id}")
    end
    return false
  end
end
