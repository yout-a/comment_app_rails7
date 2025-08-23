lock "~> 3.19.0"

set :application, "comment_app_rails7"
set :repo_url, "https://github.com/yout-a/comment_app_rails7.git"
set :branch, "main"

# 共有ファイル/ディレクトリ
# deploy.rb
append :linked_files, "config/master.key", "config/database.yml"
append :linked_dirs,  "log", "tmp/pids", "tmp/cache", "tmp/sockets",
                      "public/system", "storage"

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, "3.2.3"

set :ssh_options, auth_methods: ['publickey'],
                                  keys: ['~/.ssh/my-key-pair.pem'] 

# プロセス番号を記載したファイルの場所
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

set :deploy_to, "/var/www/comment_app_rails7"

set :log_level, :info
set :format_options, truncate: false

namespace :unicorn do
  desc "Restart unicorn via systemd"
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, "unicorn-comment_app"
    end
  end
end

after "deploy:published", "unicorn:restart"