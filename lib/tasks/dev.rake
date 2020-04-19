namespace :dev do

  DEFAULT_PASSWORD = 123456
  DEFAULT_FILE_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando o BD") { %x(rails db:drop) }
      show_spinner("Criando o BD") { %x(rails db:create) }
      show_spinner("Migrando o BD") { %x(rails db:migrate) }
      show_spinner("Cadastrando o Administrador Padrão...") { %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando Administradores Extras...") { %x(rails dev:add_extra_admins) }
      show_spinner("Cadastrando o Usuário Padrão...") { %x(rails dev:add_default_user) }
      show_spinner("Cadastrando Assuntos Padrões...") { %x(rails dev:add_subjects) }
      show_spinner("Cadastrando Perguntas e Respostas...") { %x(rails dev:add_answers_and_questions) }
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

  desc "Adiciona assuntos padrões"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILE_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Reseta o contador dos assuntos "
  task reset_subject_counter: :environment do
    show_spinner("Resetando contador dos assuntos...") do
      Subject.all.each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end

  desc "Adiciona todas as respostas no Redis"
  task add_answers_to_redis: :environment do
    show_spinner("Adicionando todas as respostas no Redis...") do
      Answer.all.each do |answer|
        Rails.cache.write(answer.id, "#{answer.question_id}@@#{answer.correct}")
      end
    end
  end

  desc "Adiciona perguntas e respostas"
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(2..5).times do
        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]
        
        add_answers(answers_array)
        elect_true_answer(answers_array)

        Question.create!(params[:question])
      end
    end
  end

  private

    def show_spinner(msg_start, msg_end = "Concluído com sucesso!")
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}...")
        spinner.auto_spin
          yield
        spinner.success("(#{msg_end})")
    end

    def add_answers(answers_array = [])
      rand(2..5).times do
        answers_array.push(
          create_answer_params
        )
      end
    end

    def elect_true_answer(answers_array = [])
      selected_index = rand(answers_array.size)
      answers_array[selected_index] = create_answer_params(true)
    end

    def create_question_params(subject = Subject.all.sample)
      { question: {
          description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
          subject: subject,
          answers_attributes: [] 
      }}
    end

    def create_answer_params(correct = false)
      { description: Faker::Lorem.sentence, correct: correct }
    end

end
