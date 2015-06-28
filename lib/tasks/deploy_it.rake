task :stats => "deploy_it:stats"

namespace :deploy_it do

  task :stats do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << ["Finders", "app/finders"]
    ::STATS_DIRECTORIES << ["Forms", "app/forms"]
    ::STATS_DIRECTORIES << ["Presenters", "app/presenters"]
    ::STATS_DIRECTORIES << ["Services", "app/services"]
  end


  namespace :api do
    desc "API Routes"
    task :routes => [:environment] do
      DeployIt::API.routes.each do |api|
        method = api.route_method.ljust(10)
        path = api.route_path.gsub(":version", api.route_version)
        puts "     #{method} #{path}"
      end
    end
  end


  namespace :ci do
    begin
      require 'ci/reporter/rake/rspec'
      ENV["CI_REPORTS"] = Rails.root.join('junit').to_s
    rescue Exception => e
    end
    task :all => ['ci:setup:rspec', 'spec']
  end


  namespace :setup do

    desc 'Create Admin User'
    task :create_admin_user => [:environment] do
      user_option = {
        login: 'admin',
        firstname: 'admin',
        lastname: 'admin',
        email: 'admin@example.org',
        admin: true,
        password: 'admin123',
        language: 'fr',
        time_zone: 'Paris'
      }

      if User.find_by_login('admin').nil?
        puts 'Create Admin user ...'
        admin = User.new(user_option)
        admin.save!
        puts 'Done!'
        puts
        puts 'login    : admin'
        puts 'email    : admin@example.org'
        puts 'password : admin123'
      else
        puts 'User admin already exists, skip ...'
      end
    end


    desc 'Create builtin Roles'
    task :create_builtin_roles => [:environment] do
      puts 'Create builtin roles ...'
      Role.non_member
      Role.anonymous
      puts 'Builtin roles created !'
    end


    desc 'Create default Roles'
    task :create_default_roles => [:environment] do
      puts 'Create default roles ...'
      create_role('Manager', DeployIt::MANAGER_PERMS)
      create_role('Developer', DeployIt::DEVELOPER_PERMS)
      puts 'Default roles created !'
    end

    desc 'Create default reserved names'
    task :create_default_reserved_names => [:environment] do
      puts 'Create default reserved names ...'
      do_create_reserved_names(DeployIt::EXCLUDED_APP_NAME)
      puts 'Default reserved names created !'
    end

    desc 'Create reserved names in bulk'
    task :create_reserved_names => [:environment] do
      puts 'Create reserved names ...'

      reserved_names = ENV['NAMES'] || ''
      reserved_names = reserved_names.split(' ')

      do_create_reserved_names(reserved_names)
      puts 'Reserved names created !'
    end

    desc 'Setup first installation'
    task :first_install => [ 'setup:create_admin_user', 'setup:create_builtin_roles', 'setup:create_default_roles', 'setup:create_default_reserved_names' ]
  end


  ## Helper Functions
  def name
    "Deploy'It"
  end


  def version
    line = File.read(Rails.root.join('lib', 'deploy_it', 'version.rb'))[/^\s*VERSION\s*=\s*.*/]
    line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
  end


  def create_role(name, perms)
    role = Role.find_by_name(name)

    if role.nil?
      role = Role.create(name: name)
    end

    role.permissions = perms
    role.save!
  end


  def do_create_reserved_names(reserved_names)
    reserved_names.each do |name|
      reserved_name = ReservedName.find_by_name(name)
      if reserved_name.nil?
        ReservedName.create(name: name)
      end
    end
  end


  desc "Show Deploy'It version"
  task :version do
    puts "#{name} #{version}"
  end

end
