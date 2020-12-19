namespace :deploy_it do

  namespace :setup do

    desc 'Create Admin User'
    task :create_admin_user => [:environment] do
      user_option = {
        firstname: 'admin',
        lastname: 'admin',
        email: 'admin@example.net',
        admin: true,
        password: 'admin123',
        language: 'fr',
        time_zone: 'Paris'
      }

      unless User.where(email: 'admin@example.net').any?
        puts 'Create Admin user ...'
        admin = User.new(user_option)
        admin.save!
        puts 'Done!'
        puts
        puts 'email    : admin@example.net'
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

end
