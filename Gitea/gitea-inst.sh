#! /bin/bash

set -e

# Create a user to manage Gitea

#read -rp 'A user managing Gitea on this system will be created, please give a name: ' git_admin

useradd -r -m -c 'Git Version Control' git

yum update -y

# Install git

yum install git -y


# Install MariaDB
# Quit the program if the user refuses to re-install MariaDB

if rpm -q mariadb-server; then
    read -rp 'already installed, remove it? Y/n: ' db_rm
    case "$db_rm" in
    y|Y)    yum remove -y mariadb mariadb-server && rm -rf /var/lib/mysql /etc/my.cnf
            yum install mariadb-server -y
    ;;
    *)      exit
    ;;
    esac
else
    yum install mariadb-server -y 
fi


systemctl enable mariadb
systemctl start mariadb

# start configuring MariaDB for Gitea server

read -rp 'mysql root password: ' root_pass

# Mariadb server hardening
mysql_secure_installation <<EOF

y
$root_pass
$root_pass
y
y
y
y
EOF

systemctl restart mariadb

# create gitea database
# create gitea dababase admin user
read -rp 'Please input gitea database name: ' gitea
read -rp 'Please input gitea database admin username: ' db_admin
read -rp 'Please input a password for the admin:' db_admin_pass
 
mysql -uroot -p${root_pass} -Be  "CREATE DATABASE ${gitea};\
GRANT ALL PRIVILEGES ON ${gitea}.* TO '${db_admin}'@'localhost'IDENTIFIED BY '${db_admin_pass}'; \
FLUSH PRIVILEGES;"
# CREATE USER ${db_admin} IDENTIFIED BY '${db_admin_pass}'; 

# Install Gitea

read -rp 'Input the Gitea version: ' ver

export VER=$ver

wget https://github.com/go-gitea/gitea/releases/download/v${VER}/gitea-${VER}-linux-amd64

chmod +x gitea-${VER}-linux-amd64
mv gitea-${VER}-linux-amd64 /usr/local/bin/gitea

# Configure Gitea

mkdir -p /var/lib/gitea/{custom,data,log}
chown -R git:git /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea

# Create Gitea daemon

cat > /etc/systemd/system/gitea.service << _EOF_

[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
After=mysql.service

[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web -c /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea
# If you want to bind Gitea to a port below 1024 uncomment
# the two values below
###
#CapabilityBoundingSet=CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
_EOF_

# Start the Gitea daemon

systemctl 'daemon-reload'
systemctl start gitea
systemctl enable gitea
