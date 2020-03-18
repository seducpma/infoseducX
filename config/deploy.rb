#set :application, "192.168.0.12"


set :application, "192.168.0.14"  # 192.168.0.14 - Servidor oficial (hera)  # 177.36.159.102 - Servidor Teste Alvaro/Alexandre

set :application, "200.168.214.58"


#set :repository, "git://github.com/seducpma/sisgered.git"
set :repository, "git://github.com/seducpma/infoseducX.git"
set :user, "atena"
set :use_sudo, false
#set :deploy_to, "/home/#{user}/sisgered.seducpma.com"
set :deploy_to, "/home/#{user}/infoseduc.seducpma.com"
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server application, :app, :web, :db, :primary => true

 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
     #run "ln -s /home/atena/photos/infoseduc /home/atena/infoseduc.seducpma.com/current/public/photos"
     run "ln -s /home/atena/photos/infoseduc /home/atena/infoseduc.seducpma.com/current/public/photos"    # direcionamento da pasta para guardar todo tipo de uoload
     #run "ln -s /home/atena/photos/sisgered /home/atena/sisgered.seducpma.com/current/public/photos"


  end

   task :custom_symlinks do
     run "rm -rf #{release_path}/config/database.yml"
     run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
     run "ln -s #{shared_path}/503.html #{release_path}/public/503.html"
   end
 end
