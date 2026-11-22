#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y mariadb-server git

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb
systemctl enable mariadb

git clone https://github.com/josejuansanchez/iaw-practica-lamp /tmp/app
mysql -e "CREATE DATABASE IF NOT EXISTS lamp_db;"
mysql -e "CREATE USER IF NOT EXISTS 'javier-lamp'@'%' IDENTIFIED BY '1234';"
mysql -e "GRANT ALL PRIVILEGES ON lamp_db.* TO 'javier-lamp'@'%';"
mysql -e "FLUSH PRIVILEGES;"
mysql lamp_db < /tmp/app/db/database.sql
rm -rf /tmp/app

ip route del default

cat << 'EOF' > /etc/systemd/system/no-internet.service
[Unit]
Description=Eliminar ruta por defecto para aislar de Internet
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/sbin/ip route del default
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable no-internet.service
