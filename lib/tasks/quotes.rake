namespace :quotes do
  task :create => :environment do
    desc "Removing old quotes." 
    Quote.destroy_all
    desc "Populating quotes." 
    File.open(File.join(Rails.root, "lib", "tasks", "quotes.txt"), "r").each do |line|
      quote, author = line.strip.split(":")
      q = Quote.new(:message => quote, :author => author)
      q.save
    end
  end
end