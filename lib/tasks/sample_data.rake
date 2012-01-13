#
# Rake task to create sample data
#
namespace :db do

    desc "Fill in the database"
    task :populate => :environment do
        Rake::Task['db:reset'].invoke

        make_admin_user
        populate_users
        add_welcome_posts
        generate_some_posts
        setup_some_relationships

    end
end

# Create 1 admin user
def make_admin_user
    admin = User.create!(:name => "Malcolm",
            :email => "mfeatonby@telkomsa.net",
            :password => "password",
            :password_confirmation => "password")
    admin.toggle!(:admin)
    admin.save
end

# Create 99 sample users
def populate_users
    99.times do |count|
        name = Faker::Name.name
        email = "#{name.gsub(/[ ']/,'_') + count.to_s}@railstutorial.org"
        password = "password"
        User.create!(:name => name, 
            :email => email, 
            :password => password,
            :password_confirmation => password)
    end
end

# Create a welcome post per user
def add_welcome_posts
    User.all.each do |user|
        user.microposts.create!(:content => "Welcome to the Sample Application!")
    end
end

# Create posts for the first 10 users
def generate_some_posts
    User.all(:limit => 10).each do |user|
        50.times do 
            user.microposts.create!(:content => Faker::Lorem.sentence(5))
        end
    end
end

# Generate some relationships
def setup_some_relationships
    users = User.all
    user  = users.first
    following = users[1..50]
    followers = users[3..40]
    following.each { |followed| user.follow!(followed) }
    followers.each { |follower| follower.follow!(user) }
end
