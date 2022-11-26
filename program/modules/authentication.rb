# frozen_string_literal: true

class Authentication
  PATH_TO_USERS = 'database/users.yml'

  def call
    read_users
    get_user
    login_user
  end

  def call_old
    read_users
    get_user
    create_user
    update_users
  end

  private

  def get_user
    puts 'Enter mail'
    @mail = gets.chomp
    puts 'Enter pass'
    @pass = gets.chomp
  end

  def create_user
    @new_user = {}
    @new_user['email'] = @mail
    crypted_pass = BCrypt::Password.create(@pass)
    @new_user['password'] = crypted_pass
    @userdata << @new_user
  end
  def check_mail
    @userdata[0]['email'] == @mail
  end
  def check_pass
    @userdata[0]['password'] == @pass
  end
  def login_user
    if check_mail && check_pass
      puts "TRUE"
    end
  end

  def read_users
    @userdata = YAML.unsafe_load(File.read(PATH_TO_USERS))
    @userdata ||= []
  end

  def update_users
    File.write(PATH_TO_USERS, @userdata.to_yaml)
  end
end

