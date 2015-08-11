class ApplicationConfigContext < SimpleDelegator

  def initialize(context)
    super(context)
  end


  def update_repository(application, params = {})
    repository = application.distant_repo
    if repository.update(params)
      # Destroy Application repository if url has changed.
      # It will be recloned by service object.
      repository.destroy_dir! if repository.url_has_changed? || repository.branch_has_changed?

      # Call service objects to perform other actions
      !repository.exists? ? repository.run_async!('clone!') : repository.run_async!('resync!')
      render_success
    else
      render_failed
    end
  end


  def update_domain_names(application, params = {})
    update_application(application, params) do |application|
      application.update_lb_route!
    end
  end


  def update_credentials(application, params = {})
    update_application(application, params) do |application|
      application.update_lb_route! if application.use_credentials?
    end
  end


  def update_env_vars(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('update_files!')
    end
  end


  def update_mount_points(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('update_files!')
    end
  end


  def ssl_certificate(application, params = {})
    return render_failed(message: t('.already_exist')) unless application.ssl_certificate.nil?
    certificate = application.build_ssl_certificate(params)
    certificate.save ? render_success : render_failed
  end


  def update_database(application, params = {})
    update_application(application, params) do |application|
      application.run_async!('create_physical_database!')
    end
  end


  def synchronize_repository(application, params = {})
    repository = application.distant_repo
    # Call service objects to perform other actions
    event_options = RefreshViewEvent.create(app_id: application.id, triggers: [repositories_application_path(application)])
    repository.run_async!('resync!', event_options: event_options)
    render_success
  end


  def restore_env_vars(application, params = {})
    execute_action(application, params) do |application|
      application.restore_env_vars!
    end
  end


  def restore_mount_points(application, params = {})
    execute_action(application, params) do |application|
      application.restore_mount_points!
    end
  end


  def reset_ssl_certificate(application, params = {})
    application.ssl_certificate = nil
    render_success
  end


  private


    def execute_action(application, params = {})
      result = yield application
      if result.success?
        application.run_async!('update_files!')
        render_success
      else
        render_failed(message: result.message_on_errors)
      end
    end


    def update_application(application, params = {})
      if application.update(params)
        yield application
        render_success
      else
        render_failed
      end
    end

end
