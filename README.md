stop a ruby server 
(Type CNTRL-C, not CMMND-C)

----
start a ruby server
ruby [FILENAME] -p $PORT -0 $IP

stationapp@stationapp:/home/ubuntu/workspace (master) $ ruby 
.bundle/           README.md          public/
.c9/               Untitled1          station2.html.erb
.git/              application.rb     twitter.rb
Gemfile            config.ru          views/
Gemfile.lock       facebook.rb        
Procfile           instagram.rb       
stationapp@stationapp:/home/ubuntu/workspace (master) $ ruby application.rb -p $PORT -o $IP
== Sinatra/1.4.5 has taken the stage on 8080 for development with backup from Thin
Thin web server (v1.6.2 codename Doc Brown)
Maximum connections set to 1024
Listening on 0.0.0.0:8080, CTRL+C to stop