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

  def terms
    @title = 'Terms of Use'
  end

  def privacy
    @title = 'Privacy Policy'
  end
end
