module ApplicationHelper
  def title
    @title.nil? ? "#{ConstantsHelper::WEB_SITE_NAME}" : "#{ConstantsHelper::WEB_SITE_NAME} | #{@title}"
  end

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end
end
