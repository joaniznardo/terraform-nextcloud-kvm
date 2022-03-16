#!/bin/bash

export USER_MIN=minio-user

sudo useradd --system minio-user -s /bin/false

wget https://dl.minio.io/server/minio/release/linux-amd64/minio
sudo chown $USER_MIN. minio
sudo chmod +x minio
sudo mv minio /usr/local/bin
sudo mkdir /etc/minio /usr/local/share/minio
sudo chown $USER_MIN. /etc/minio
sudo chown $USER_MIN. /usr/local/share/minio
sudo tee /etc/default/minio <<EOF
MINIO_ACCESS_KEY="clau-access-minio"
MINIO_SECRET_KEY="minio-secret"
MINIO_VOLUMES="/usr/local/share/minio/"
MINIO_OPTS="-C /etc/minio --address 10.0.100.46:9000"
EOF

curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service
sudo mv minio.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable minio
sudo systemctl start minio

