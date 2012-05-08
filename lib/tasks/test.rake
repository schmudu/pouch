namespace :test do
  task :create_users => :environment do
    desc "Creating test users." 
    TestUser.create!(:email => 'patrick.robin.lee@gmail.com', :password => 'shortGuy')
    TestUser.create!(:email => 'patrick.g.lorenzo@gmail.com', :password => 'myTwin')
    TestUser.create!(:email => 'ryankellygraphics@gmail.com', :password => 'easternSho')
  end
end