#!/bin/bash -e
#
# /etc/init.d/twitter-ua.sh: Start the twitter-ua client
#
### BEGIN INIT INFO
# Provides:       twitter-ua
# Required-Start: $local_fs $syslog $remote_fs
# Required-Stop: $remote_fs
# Default-Start:  2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start twitter-ua server
# Description: twitter-ua client
### END INIT INFO


export PATH="/root/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

case "$1" in
  start)
			#/root/harrys/twitter_ua.rb 2>&1 >> /var/log/twitter.log
			/root/harrys/twitter_ua.rb 2>&1 >> /var/log/twitter.log &
    ;;

  stop)
			pkill -f "ruby /root/harrys/twitter_ua.rb"
    ;;

  restart)
			pkill -f "ruby /root/harrys/twitter_ua.rb"
			/root/harrys/twitter_ua.rb 2>&1 >> /var/log/twitter.log
    ;;

  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|restart}"
    RET=1
    ;;
esac


exit $RET
