namespace :search do
  task :rebuild => :environment do
=begin
    Tire.index 'resources' do
      desc "Remove resource mapping"
      delete

      desc "Create resource mapping"
      create :mappings => {
        :resource => {
          :properties => {
            :title                    => { :type => 'string', :index => 'not_analyzed'                          },
            :description              => { :type => 'string', :index => 'not_analyzed'                          },
            :author                   => { :type => 'string', :index => 'not_analyzed'                          },
            #:tags           => { :type => 'string', :analyzer => 'keyword'                            },
            :extracted_content        => { :type => 'string', :analyzer => 'snowball'                           }
          }
        }
      }
    end
=end
    desc "Removing old index." 
    Resource.tire.index.delete
    desc "Rebuilding resource index." 
    Resource.tire.index.import Resource.all
  end
end