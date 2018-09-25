#!/bin/bash -ex
#
source config.cfg
source functions.sh

echocolor "Installing CRUDINI"
sleep 3

apt-get -y install python-pip
pip install \
    https://pypi.python.org/packages/source/c/crudini/crudini-0.7.tar.gz

echocolor "Install python client"
apt-get -y install python-openstackclient
sleep 5

echocolor "Install and config NTP"
sleep 3


apt-get -y install chrony
ntpfile=/etc/chrony/chrony.conf
cp $ntpfile $ntpfile.orig

sed -i 's/server 0.debian.pool.ntp.org offline minpoll 8/ \
server 1.vn.pool.ntp.org iburst \
server 0.asia.pool.ntp.org iburst \
server 3.asia.pool.ntp.org iburst/g' $ntpfile

sed -i 's/server 1.debian.pool.ntp.org offline minpoll 8/ \
# server 1.debian.pool.ntp.org offline minpoll 8/g' $ntpfile

sed -i 's/server 2.debian.pool.ntp.org offline minpoll 8/ \
# server 2.debian.pool.ntp.org offline minpoll 8/g' $ntpfile

sed -i 's/server 3.debian.pool.ntp.org offline minpoll 8/ \
# server 3.debian.pool.ntp.org offline minpoll 8/g' $ntpfile

##############################################
echocolor "Install and Config RabbitMQ"
sleep 3

apt-get install rabbitmq-server -y
rabbitmqctl add_user openstack $RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
# rabbitmqctl change_password guest $RABBIT_PASS
sleep 3

service rabbitmq-server restart
echocolor "Finish setup pre-install package !!!"

echocolor "Install MYSQL"
sleep 3

echo mysql-server mysql-server/root_password password \
$MYSQL_PASS | debconf-set-selections
echo mysql-server mysql-server/root_password_again password \
$MYSQL_PASS | debconf-set-selections
apt-get -y install mariadb-server python-mysqldb curl

echocolor "Configuring MYSQL"
sleep 5

mysql_server=/etc/mysql/mariadb.conf.d/50-server.cnf
test -f $mysql_server.orig || cp $mysql_server $mysql_server.orig
rm $mysql_server
touch $ifaces
cat << EOF >> $mysql_server
[server]

[mysqld]

user            = mysql
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
port            = 3306
basedir         = /usr
datadir         = /var/lib/mysql
tmpdir          = /tmp
lc-messages-dir = /usr/share/mysql
skip-external-locking

bind-address            = 0.0.0.0

key_buffer_size         = 16M
max_allowed_packet      = 16M
thread_stack            = 192K
thread_cache_size       = 8
myisam-recover         = BACKUP

query_cache_limit       = 1M
query_cache_size        = 16M

log_error = /var/log/mysql/error.log
expire_logs_days        = 10
max_binlog_size   = 100M

character-set-server  = utf8
collation-server      = utf8_general_ci

[embedded]

[mariadb]

[mariadb-10.0]

EOF

mysql_client=/etc/mysql/mariadb.conf.d/50-client.cnf
ops_edit $mysql_client client default-character-set utf8

sleep 5
echocolor "Restarting MYSQL"
service mysql restart

sleep 5
echocolor "Rebooting machine ..."
init 6
#