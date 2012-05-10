module ApplicationHelper
  def title
    @title.nil? ? "#{ConstantsHelper::WEB_SITE_NAME}" : "#{ConstantsHelper::WEB_SITE_NAME} | #{@title}"
  end
end
