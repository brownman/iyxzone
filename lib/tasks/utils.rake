require 'pty'
require 'expect'

namespace :utils do

  desc "处理日志"
  task :tail_log => :environment do
    `mv #{RAILS_ROOT}/log/production.log /tmp/log/#{Time.now.strftime("%Y-%m-%d")}.log`
    `touch #{RAILS_ROOT}/log/production.log`
  end

  desc "重启所有rails需要的程序"
  task :restart => :environment do
    # restart mysql
    puts `service mysqld restart`
    # restart httpd
    puts `service httpd restart`
    # restart postfix
    puts `service postfix restart`
    # restart impad
    puts `service cyrus-imapd restart`
    # synchronize time
    puts `ntpdate 0.centos.pool.ntp.org`
    # start memcached
    puts `/usr/local/monit_bin/memcached restart`
    # juggernaut
    puts `/usr/local/monit_bin/juggernaut restart`
  end

  task :generate_captcha => :environment do
    `mkdir -p public/images/captcha`
    
    if Captcha.count != 0
      `rm -f public/images/captcha/*`
      Captcha.destroy_all
    end

    s= Time.now
    1000.times {|i| Captcha.generate}
    puts "#{Time.now - s} sec"
  end 

end
