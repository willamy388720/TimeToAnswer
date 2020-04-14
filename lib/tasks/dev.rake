namespace :dev do

  DEFAULT_PASSWORD = 123456

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando o BD") { %x(rails db:drop) }
      show_spinner("Criando o BD") { %x(rails db:create) }
      show_spinner("Migrando o BD") { %x(rails db:migrate) }
      show_spinner("Cadastrando o Administrador Padrão") { %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando Administradores Extras") { %x(rails dev:add_extra_admins) }
      show_spinner("Cadastrando o Usuário Padrão") { %x(rails dev:add_default_user) }
      #%x(rails dev:add_mining_types)

    else
      puts "Você não está no ambiente de desenvolvimento"
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o administradore extras"
  task add_extra_admins: :environment do
    10.times do
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private

    def show_spinner(msg_start, msg_end = "Concluído com sucesso!")
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}...")
        spinner.auto_spin
          yield
        spinner.success("(#{msg_end})")
    end

end
