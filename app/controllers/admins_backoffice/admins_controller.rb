class AdminsBackoffice::AdminsController < AdminsBackofficeController
  before_action :set_admin, only: [:edit, :update]
  
  def index
    @admins = Admin.all
  end

  def edit
    #
  end

  def update
    params_admin = params.require(:admin).permit(:email, :password, :password_confirmation)
    if @admin.update(params_admin)
      redirect_to admins_backoffice_admins_path, notice: "Administrador atualizado com sucesso!"
    else
      render :edit
    end
  end

  private
    def set_admin
      @admin = Admin.find(params[:id])
    end
end
