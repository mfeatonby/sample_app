#
# Rake task to create sample data
#
namespace :db do

    desc "Fill in the database"
    task :populate => :environment do
        Rake::Task['db:reset'].invoke
        admin = User.create!(:name => "Malcolm",
                     :email => "mfeatonby@telkomsa.net",
                     :password => "password",
                     :password_confirmation => "password")
        admin.toggle!(:admin)
        admin.save
        puts "Adding #{admin.name}"
        99.times do |count|
            name = Faker::Name.name
            email = "#{name.gsub(/[ ']/,'_') + count.to_s}@railstutorial.org"
            password = "password"
            User.create!(:name => name, 
                     :email => email, 
                     :password => password,
                     :password_confirmation => password)
            puts "Adding #{name}"
        end
    end
end
