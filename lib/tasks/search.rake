namespace :search do
  task :rebuild => :environment do
    desc "Removing old index." 
    Resource.tire.index.delete
    desc "Rebuilding resource index." 
    Resource.tire.index.import Resource.all
  end
end