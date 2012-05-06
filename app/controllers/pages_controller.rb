class PagesController < ApplicationController
  def contact
    @title = 'Contact Us'
  end

  def home
    @title = 'Home'
  end

  def about
    @title = 'About'
  end

  def not_found
    @title = 'Page Not Found'
  end

  def terms
    @title = 'Terms of Use'
  end

  def privacy
    @title = 'Privacy Policy'
  end

  def unauthorized
    @title = 'Unauthorized'
  end
end
