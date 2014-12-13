require 'parse-ruby-client'
Parse.init :application_id => "D7ZF2F0A8jiQcXdeFOVZbeiPa1Jc1A4bxC2v7LHb",
           :api_key        => "XIQOIu68qpFwgjt2szgFNJfeChpdUT2UzaeF1EZX"
           
#Registration form
post '/signup' do
    user = params[:username]
    pass = params[:password]

    newUser = Parse::User.new({
        :username => user.downcase,
        :password => pass,
    })
    newUser.save
    
    erb :"signup.html"
end

#Log in form
post '/signin' do
    usera = params[:user]
    user = usera.downcase
    pass = params[:pass]
    
    begin
        login = Parse::User.authenticate(user, pass)
    rescue Parse::ParseProtocolError
        "Invalid credentials!"
    end
    if login != nil
        session[:user] = usera
        @signinstatus = "Signed in"
        redirect to "/"
    end
end