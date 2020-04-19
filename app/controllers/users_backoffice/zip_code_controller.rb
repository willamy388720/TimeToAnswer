class UsersBackoffice::ZipCodeController < UsersBackofficeController
  def show
    @cep = Cep.new(params[:zip_code])
  end
end
