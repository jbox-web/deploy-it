class InitSchema < ActiveRecord::Migration[5.2]
  def up
    create_table "application_addons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.string "type"
      t.text "params"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id", "type"], name: "index_application_addons_on_application_id_and_type", unique: true
    end
    create_table "application_credentials", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.string "login"
      t.string "password"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id", "login"], name: "index_application_credentials_on_application_id_and_login", unique: true
      t.index ["application_id"], name: "index_application_credentials_on_application_id"
    end
    create_table "application_databases", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.integer "server_id"
      t.string "db_type"
      t.string "db_name"
      t.string "db_user"
      t.string "db_pass"
      t.boolean "db_created", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id"], name: "index_application_databases_on_application_id", unique: true
    end
    create_table "application_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.string "version"
      t.string "language"
      t.text "extra_attributes"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name", "version", "language"], name: "index_application_types_on_name_and_version_and_language", unique: true
    end
    create_table "applications", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_type_id"
      t.integer "stage_id"
      t.string "name"
      t.string "identifier", limit: 13
      t.string "deploy_url"
      t.string "domain_name"
      t.string "image_type"
      t.string "buildpack"
      t.integer "instance_number", default: 1
      t.integer "max_memory", default: 256
      t.boolean "use_cron", default: false
      t.boolean "use_ssl", default: false
      t.boolean "use_workers", default: false
      t.boolean "debug_mode", default: false
      t.boolean "use_credentials", default: false
      t.boolean "marked_for_deletion", default: false
      t.text "description"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_type_id"], name: "index_applications_on_application_type_id"
      t.index ["deploy_url"], name: "index_applications_on_deploy_url", unique: true
      t.index ["identifier", "stage_id"], name: "index_applications_on_identifier_and_stage_id", unique: true
      t.index ["stage_id"], name: "index_applications_on_stage_id"
    end
    create_table "buildpacks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.string "url"
      t.text "description"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name"], name: "index_buildpacks_on_name", unique: true
    end
    create_table "builds", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.integer "author_id"
      t.integer "push_id"
      t.string "request_id"
      t.string "state"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id"], name: "index_builds_on_application_id"
      t.index ["author_id"], name: "index_builds_on_author_id"
      t.index ["push_id"], name: "index_builds_on_push_id"
    end
    create_table "configs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.text "values"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id"], name: "index_configs_on_application_id"
    end
    create_table "container_events", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "container_id"
      t.string "type"
      t.string "message"
      t.boolean "seen", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["container_id"], name: "index_container_events_on_container_id"
    end
    create_table "containers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.integer "server_id"
      t.integer "release_id"
      t.string "type"
      t.string "image_name"
      t.integer "cpu_shares", default: 256
      t.integer "memory", default: 256
      t.integer "port"
      t.string "docker_id"
      t.boolean "marked_for_deletion", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id"], name: "index_containers_on_application_id"
      t.index ["docker_id"], name: "index_containers_on_docker_id"
    end
    create_table "docker_images", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.string "start_cmd"
      t.text "description"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name"], name: "index_docker_images_on_name", unique: true
    end
    create_table "domain_names", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.string "domain_name"
      t.string "mode"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id"], name: "index_domain_names_on_application_id"
      t.index ["domain_name"], name: "index_domain_names_on_domain_name", unique: true
    end
    create_table "env_vars", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.string "key"
      t.string "value"
      t.boolean "masked", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id", "key"], name: "index_env_vars_on_application_id_and_key", unique: true
      t.index ["application_id"], name: "index_env_vars_on_application_id"
    end
    create_table "groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name"], name: "index_groups_on_name", unique: true
    end
    create_table "groups_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "group_id", null: false
      t.integer "user_id", null: false
      t.index ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", unique: true
      t.index ["group_id"], name: "index_groups_users_on_group_id"
      t.index ["user_id"], name: "index_groups_users_on_user_id"
    end
    create_table "locks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "token", null: false
      t.index ["token"], name: "index_locks_on_token", unique: true
    end
    create_table "member_roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "member_id", null: false
      t.integer "role_id", null: false
      t.integer "inherited_from"
      t.index ["member_id"], name: "index_member_roles_on_member_id"
      t.index ["role_id"], name: "index_member_roles_on_role_id"
    end
    create_table "members", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "enrolable_id"
      t.string "enrolable_type"
      t.integer "application_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id"], name: "index_members_on_application_id"
      t.index ["enrolable_id", "enrolable_type", "application_id"], name: "unique_member", unique: true
      t.index ["enrolable_id"], name: "index_members_on_enrolable_id"
    end
    create_table "mount_points", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.string "source"
      t.string "target"
      t.string "step"
      t.boolean "active", default: true
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id"], name: "index_mount_points_on_application_id"
    end
    create_table "platform_credentials", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "platform_id"
      t.string "fingerprint"
      t.text "public_key"
      t.text "private_key"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["fingerprint"], name: "index_platform_credentials_on_fingerprint", unique: true
      t.index ["platform_id"], name: "index_platform_credentials_on_platform_id", unique: true
    end
    create_table "platforms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.string "identifier"
      t.text "description"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["identifier"], name: "index_platforms_on_identifier", unique: true
    end
    create_table "pushes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.integer "author_id"
      t.string "ref_name"
      t.string "old_revision"
      t.string "new_revision"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id"], name: "index_pushes_on_application_id"
      t.index ["author_id"], name: "index_pushes_on_author_id"
    end
    create_table "releases", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.integer "author_id"
      t.integer "build_id"
      t.integer "config_id"
      t.integer "version"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id"], name: "index_releases_on_application_id"
      t.index ["author_id"], name: "index_releases_on_author_id"
      t.index ["build_id"], name: "index_releases_on_build_id"
      t.index ["config_id"], name: "index_releases_on_config_id"
      t.index ["version"], name: "index_releases_on_version"
    end
    create_table "repositories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.string "type"
      t.string "url"
      t.string "relative_path"
      t.string "branch", default: "master"
      t.boolean "have_credentials", default: false
      t.integer "credential_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id", "type"], name: "index_repositories_on_application_id_and_type", unique: true
      t.index ["credential_id"], name: "index_repositories_on_credential_id"
    end
    create_table "repository_credentials", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.string "type"
      t.string "fingerprint"
      t.text "public_key"
      t.text "private_key"
      t.string "login"
      t.string "password"
      t.boolean "generated"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["fingerprint"], name: "index_repository_credentials_on_fingerprint"
    end
    create_table "reserved_names", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.index ["name"], name: "index_reserved_names_on_name", unique: true
    end
    create_table "roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.integer "builtin", default: 0
      t.integer "position", default: 1
      t.text "permissions"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name"], name: "index_roles_on_name", unique: true
    end
    create_table "server_roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "platform_id"
      t.integer "server_id"
      t.string "name"
      t.string "alternative_host", default: ""
      t.integer "port"
      t.integer "connection_timeout", default: 10
      t.boolean "default_server", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name"], name: "index_server_roles_on_name"
      t.index ["platform_id"], name: "index_server_roles_on_platform_id"
      t.index ["server_id", "name"], name: "index_server_roles_on_server_id_and_name", unique: true
      t.index ["server_id"], name: "index_server_roles_on_server_id"
    end
    create_table "servers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "platform_id"
      t.string "host_name"
      t.string "ip_address"
      t.string "ssh_user", default: "root"
      t.integer "ssh_port", default: 22
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["host_name"], name: "index_servers_on_host_name", unique: true
      t.index ["ip_address"], name: "index_servers_on_ip_address", unique: true
      t.index ["platform_id"], name: "index_servers_on_platform_id"
    end
    create_table "ssh_public_keys", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "user_id"
      t.string "title"
      t.string "fingerprint"
      t.text "key"
      t.boolean "active", default: true
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["fingerprint"], name: "index_ssh_public_keys_on_fingerprint"
      t.index ["user_id"], name: "index_ssh_public_keys_on_user_id"
    end
    create_table "ssl_certificates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "application_id"
      t.text "ssl_crt"
      t.text "ssl_key"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["application_id"], name: "index_ssl_certificates_on_application_id", unique: true
    end
    create_table "stages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.string "identifier"
      t.integer "platform_id"
      t.string "portal_url"
      t.string "database_name_prefix"
      t.string "domain_name_suffix"
      t.text "description"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["identifier", "platform_id"], name: "index_stages_on_identifier_and_platform_id", unique: true
      t.index ["platform_id"], name: "index_stages_on_platform_id"
    end
    create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "firstname"
      t.string "lastname"
      t.string "language"
      t.string "time_zone"
      t.boolean "admin", default: false
      t.boolean "enabled", default: true
      t.string "authentication_token"
      t.string "api_token"
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["api_token"], name: "index_users_on_api_token", unique: true
      t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
