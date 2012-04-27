class RegistrationsController < Devise::RegistrationsController
  def build_resource(hash=nil)
    #override devise method and save created_ip
    hash ||= params[resource_name] || {}
    self.resource = resource_class.new_with_session(hash, session)
    self.resource.created_ip = request.remote_ip
  end
end