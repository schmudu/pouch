namespace :grades do
  task :create => :environment do
    desc "Removing old grades." 
    Grade.destroy_all
    desc "Populating grades." 
    File.open(File.join(Rails.root, "lib", "tasks", "grades.txt"), "r").each do |line|
      grade = line.strip
      g = Grade.new(:title => grade)
      g.save
    end
  end
end