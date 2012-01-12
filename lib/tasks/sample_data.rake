#
# Rake task to create sample data
#
namespace :db do

    desc "Fill in the database"
    task :populate => :environment do
        Rake::Task['db:reset'].invoke

        # Create 1 admin user

        admin = User.create!(:name => "Malcolm",
                     :email => "mfeatonby@telkomsa.net",
                     :password => "password",
                     :password_confirmation => "password")
        admin.toggle!(:admin)
        admin.save

        # Create 99 sample users

        99.times do |count|
            name = Faker::Name.name
            email = "#{name.gsub(/[ ']/,'_') + count.to_s}@railstutorial.org"
            password = "password"
            User.create!(:name => name, 
                     :email => email, 
                     :password => password,
                     :password_confirmation => password)
        end

        # Create a welcome post per user
        User.all.each do |user|
            user.microposts.create!(:content => "Welcome to the Sample Application!")
        end

        # Create posts for the first 10 users
        User.all(:limit => 10).each do |user|
            50.times do 
                user.microposts.create!(:content => Faker::Lorem.sentence(5))
            end
        end

    end
end
