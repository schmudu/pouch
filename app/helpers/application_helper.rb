module ApplicationHelper
  def title
    @title.nil? ? "#{t 'site.name'}" : "#{t 'site.name'} | #{@title}"
  end
end
