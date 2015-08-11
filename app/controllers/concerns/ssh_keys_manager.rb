module SshKeysManager
  extend ActiveSupport::Concern

  included do
    before_action :find_user
    before_action :find_user_ssh_keys
    before_action :find_ssh_key, only: :destroy
  end


  def index
    @ssh_key = SshPublicKey.new
  end


  def create
    @ssh_key = SshPublicKey.new(ssh_key_params.merge(user: @user))
    render_success if @ssh_key.save
  end


  def destroy
    render_success if request.delete? && @ssh_key.destroy
  end


  private


    def render_success
      flash[:notice] = t('.notice')
      # Call service objects to perform other actions
      call_service_objects
      # Reset form object
      @ssh_key = SshPublicKey.new
    end


    def ssh_key_params
      params.require(:ssh_public_key).permit(:title, :key)
    end


    def call_service_objects
      case action_name
      when 'create'
        result = @ssh_key.add_to_authorized_keys!
      when 'destroy'
        result = @ssh_key.remove_from_authorized_keys!
      end
      flash[:alert] = result.errors if !result.success?
    end


    def find_user
      raise NotImplementedError
    end


    def find_ssh_key
      @ssh_key = @user.ssh_public_keys.find_by_id(params[:id])
    end


    def find_user_ssh_keys
      @ssh_keys = @user.ssh_public_keys
    end

end
