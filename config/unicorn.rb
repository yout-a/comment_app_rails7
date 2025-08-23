# ワーカー数
worker_processes 2

# アプリケーションのディレクトリ
app_path = "/var/www/comment_app_rails7"

# Unicornが参照するディレクトリ
working_directory "#{app_path}/current"

# ソケット通信の設定
listen "#{app_path}/shared/tmp/sockets/unicorn.sock", backlog: 64

# プロセスIDの保存先
pid "#{app_path}/shared/tmp/pids/unicorn.pid"

# ログの出力先
stderr_path "#{app_path}/shared/log/unicorn.stderr.log"
stdout_path "#{app_path}/shared/log/unicorn.stdout.log"

# タイムアウト時間
timeout 60

# ダウンタイムなしで再起動するための設定
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending QUIT instead'
    Process.kill 'QUIT', Process.pid
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end
end
