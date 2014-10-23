#!/bin/bash

if [ ! -f /var/log/idmsetup ];
then
    echo "CREATE DATABASE composeidentity2" | mysql -uroot -proot
    echo "GRANT ALL ON *.* TO 'root'@'localhost'" | mysql -uroot -proot
    echo "flush privileges" | mysql -uroot -proot
    sudo touch /var/log/idmsetup
fi