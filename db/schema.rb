# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150809044327) do

  create_table "application_credentials", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.string   "login",          limit: 255
    t.string   "password",       limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "application_credentials", ["application_id", "login"], name: "index_application_credentials_on_application_id_and_login", unique: true, using: :btree
  add_index "application_credentials", ["application_id"], name: "index_application_credentials_on_application_id", using: :btree

  create_table "application_databases", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.integer  "server_id",      limit: 4
    t.string   "db_type",        limit: 255
    t.string   "db_name",        limit: 255
    t.string   "db_user",        limit: 255
    t.string   "db_pass",        limit: 255
    t.boolean  "db_created",                 default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "application_databases", ["application_id"], name: "index_application_databases_on_application_id", unique: true, using: :btree

  create_table "application_types", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "version",          limit: 255
    t.string   "language",         limit: 255
    t.text     "extra_attributes", limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "application_types", ["name", "version", "language"], name: "index_application_types_on_name_and_version_and_language", unique: true, using: :btree

  create_table "applications", force: :cascade do |t|
    t.integer  "application_type_id", limit: 4
    t.integer  "stage_id",            limit: 4
    t.string   "name",                limit: 255
    t.string   "identifier",          limit: 13
    t.string   "deploy_url",          limit: 255
    t.string   "domain_name",         limit: 255
    t.string   "image_type",          limit: 255
    t.string   "buildpack",           limit: 255
    t.integer  "instance_number",     limit: 4,     default: 1
    t.boolean  "use_cron",                          default: false
    t.boolean  "use_ssl",                           default: false
    t.boolean  "debug_mode",                        default: false
    t.boolean  "use_credentials",                   default: false
    t.boolean  "marked_for_deletion",               default: false
    t.text     "description",         limit: 65535
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "applications", ["application_type_id"], name: "index_applications_on_application_type_id", using: :btree
  add_index "applications", ["deploy_url"], name: "index_applications_on_deploy_url", unique: true, using: :btree
  add_index "applications", ["identifier", "stage_id"], name: "index_applications_on_identifier_and_stage_id", unique: true, using: :btree
  add_index "applications", ["stage_id"], name: "index_applications_on_stage_id", using: :btree

  create_table "buildpacks", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "url",         limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "buildpacks", ["name"], name: "index_buildpacks_on_name", unique: true, using: :btree

  create_table "builds", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.integer  "author_id",      limit: 4
    t.integer  "push_id",        limit: 4
    t.string   "request_id",     limit: 255
    t.string   "state",          limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "builds", ["application_id"], name: "index_builds_on_application_id", using: :btree
  add_index "builds", ["author_id"], name: "index_builds_on_author_id", using: :btree
  add_index "builds", ["push_id"], name: "index_builds_on_push_id", using: :btree

  create_table "configs", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.text     "values",         limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "configs", ["application_id"], name: "index_configs_on_application_id", using: :btree

  create_table "containers", force: :cascade do |t|
    t.integer  "application_id",      limit: 4
    t.integer  "server_id",           limit: 4
    t.integer  "release_id",          limit: 4
    t.string   "type",                limit: 255
    t.integer  "cpu_shares",          limit: 4,   default: 256
    t.integer  "memory",              limit: 4,   default: 256
    t.string   "docker_id",           limit: 255
    t.boolean  "marked_for_deletion",             default: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "containers", ["application_id"], name: "index_containers_on_application_id", using: :btree
  add_index "containers", ["docker_id"], name: "index_containers_on_docker_id", using: :btree

  create_table "docker_images", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "docker_images", ["name"], name: "index_docker_images_on_name", unique: true, using: :btree

  create_table "domain_names", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.string   "domain_name",    limit: 255
    t.string   "mode",           limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "domain_names", ["application_id"], name: "index_domain_names_on_application_id", using: :btree
  add_index "domain_names", ["domain_name"], name: "index_domain_names_on_domain_name", unique: true, using: :btree

  create_table "env_vars", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.string   "key",            limit: 255
    t.string   "value",          limit: 255
    t.boolean  "masked",                     default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "env_vars", ["application_id", "key"], name: "index_env_vars_on_application_id_and_key", unique: true, using: :btree
  add_index "env_vars", ["application_id"], name: "index_env_vars_on_application_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", limit: 4, null: false
    t.integer "user_id",  limit: 4, null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", unique: true, using: :btree
  add_index "groups_users", ["group_id"], name: "index_groups_users_on_group_id", using: :btree
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id", using: :btree

  create_table "locks", force: :cascade do |t|
    t.string "token", limit: 255, null: false
  end

  add_index "locks", ["token"], name: "index_locks_on_token", unique: true, using: :btree

  create_table "member_roles", force: :cascade do |t|
    t.integer "member_id",      limit: 4, null: false
    t.integer "role_id",        limit: 4, null: false
    t.integer "inherited_from", limit: 4
  end

  add_index "member_roles", ["member_id"], name: "index_member_roles_on_member_id", using: :btree
  add_index "member_roles", ["role_id"], name: "index_member_roles_on_role_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "enrolable_id",   limit: 4
    t.string   "enrolable_type", limit: 255
    t.integer  "application_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "members", ["application_id"], name: "index_members_on_application_id", using: :btree
  add_index "members", ["enrolable_id", "enrolable_type", "application_id"], name: "unique_member", unique: true, using: :btree
  add_index "members", ["enrolable_id"], name: "index_members_on_enrolable_id", using: :btree

  create_table "mount_points", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.string   "source",         limit: 255
    t.string   "target",         limit: 255
    t.string   "step",           limit: 255
    t.boolean  "active",                     default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "mount_points", ["application_id"], name: "index_mount_points_on_application_id", using: :btree

  create_table "platform_credentials", force: :cascade do |t|
    t.integer  "platform_id", limit: 4
    t.string   "fingerprint", limit: 255
    t.text     "public_key",  limit: 65535
    t.text     "private_key", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "platform_credentials", ["fingerprint"], name: "index_platform_credentials_on_fingerprint", unique: true, using: :btree
  add_index "platform_credentials", ["platform_id"], name: "index_platform_credentials_on_platform_id", unique: true, using: :btree

  create_table "platforms", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "identifier",  limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "platforms", ["identifier"], name: "index_platforms_on_identifier", unique: true, using: :btree

  create_table "pushes", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.integer  "author_id",      limit: 4
    t.string   "ref_name",       limit: 255
    t.string   "old_revision",   limit: 255
    t.string   "new_revision",   limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "pushes", ["application_id"], name: "index_pushes_on_application_id", using: :btree
  add_index "pushes", ["author_id"], name: "index_pushes_on_author_id", using: :btree

  create_table "releases", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.integer  "author_id",      limit: 4
    t.integer  "build_id",       limit: 4
    t.integer  "config_id",      limit: 4
    t.integer  "version",        limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "releases", ["application_id"], name: "index_releases_on_application_id", using: :btree
  add_index "releases", ["author_id"], name: "index_releases_on_author_id", using: :btree
  add_index "releases", ["build_id"], name: "index_releases_on_build_id", using: :btree
  add_index "releases", ["config_id"], name: "index_releases_on_config_id", using: :btree
  add_index "releases", ["version"], name: "index_releases_on_version", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.integer  "application_id",   limit: 4
    t.string   "type",             limit: 255
    t.string   "url",              limit: 255
    t.string   "relative_path",    limit: 255
    t.string   "branch",           limit: 255, default: "master"
    t.boolean  "have_credentials",             default: false
    t.integer  "credential_id",    limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "repositories", ["application_id", "type"], name: "index_repositories_on_application_id_and_type", unique: true, using: :btree
  add_index "repositories", ["credential_id"], name: "index_repositories_on_credential_id", using: :btree

  create_table "repository_credentials", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "type",        limit: 255
    t.string   "fingerprint", limit: 255
    t.text     "public_key",  limit: 65535
    t.text     "private_key", limit: 65535
    t.string   "login",       limit: 255
    t.string   "password",    limit: 255
    t.boolean  "generated"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "repository_credentials", ["fingerprint"], name: "index_repository_credentials_on_fingerprint", using: :btree

  create_table "reserved_names", force: :cascade do |t|
    t.string "name", limit: 255
  end

  add_index "reserved_names", ["name"], name: "index_reserved_names_on_name", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "builtin",     limit: 4,     default: 0
    t.integer  "position",    limit: 4,     default: 1
    t.text     "permissions", limit: 65535
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "server_roles", force: :cascade do |t|
    t.integer  "platform_id",        limit: 4
    t.integer  "server_id",          limit: 4
    t.string   "name",               limit: 255
    t.string   "alternative_host",   limit: 255, default: ""
    t.integer  "port",               limit: 4
    t.integer  "connection_timeout", limit: 4,   default: 10
    t.boolean  "default_server",                 default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "server_roles", ["name"], name: "index_server_roles_on_name", using: :btree
  add_index "server_roles", ["platform_id"], name: "index_server_roles_on_platform_id", using: :btree
  add_index "server_roles", ["server_id", "name"], name: "index_server_roles_on_server_id_and_name", unique: true, using: :btree
  add_index "server_roles", ["server_id"], name: "index_server_roles_on_server_id", using: :btree

  create_table "servers", force: :cascade do |t|
    t.integer  "platform_id", limit: 4
    t.string   "host_name",   limit: 255
    t.string   "ip_address",  limit: 255
    t.string   "ssh_user",    limit: 255, default: "root"
    t.integer  "ssh_port",    limit: 4,   default: 22
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "servers", ["host_name"], name: "index_servers_on_host_name", unique: true, using: :btree
  add_index "servers", ["ip_address"], name: "index_servers_on_ip_address", unique: true, using: :btree
  add_index "servers", ["platform_id"], name: "index_servers_on_platform_id", using: :btree

  create_table "ssh_public_keys", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "title",       limit: 255
    t.string   "fingerprint", limit: 255
    t.text     "key",         limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "ssh_public_keys", ["fingerprint"], name: "index_ssh_public_keys_on_fingerprint", using: :btree
  add_index "ssh_public_keys", ["user_id"], name: "index_ssh_public_keys_on_user_id", using: :btree

  create_table "ssl_certificates", force: :cascade do |t|
    t.integer  "application_id", limit: 4
    t.text     "ssl_crt",        limit: 65535
    t.text     "ssl_key",        limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ssl_certificates", ["application_id"], name: "index_ssl_certificates_on_application_id", unique: true, using: :btree

  create_table "stages", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "identifier",           limit: 255
    t.integer  "platform_id",          limit: 4
    t.string   "portal_url",           limit: 255
    t.string   "database_name_prefix", limit: 255
    t.string   "domain_name_suffix",   limit: 255
    t.text     "description",          limit: 65535
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "stages", ["identifier", "platform_id"], name: "index_stages_on_identifier_and_platform_id", unique: true, using: :btree
  add_index "stages", ["platform_id"], name: "index_stages_on_platform_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "firstname",              limit: 255
    t.string   "lastname",               limit: 255
    t.string   "language",               limit: 255
    t.string   "time_zone",              limit: 255
    t.boolean  "admin",                              default: false
    t.boolean  "enabled",                            default: true
    t.string   "authentication_token",   limit: 255
    t.string   "api_token",              limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "users", ["api_token"], name: "index_users_on_api_token", unique: true, using: :btree
  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
