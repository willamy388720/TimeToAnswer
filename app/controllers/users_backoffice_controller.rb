class UsersBackofficeController < ApplicationController
    before_action :authenticate_admin!
    layout "users_backoffice"
end
