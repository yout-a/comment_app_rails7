namespace :unicorn do
  desc "Restart unicorn via systemd"
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, "unicorn-comment_app"
    end
  end
end

after "deploy:published", "unicorn:restart"