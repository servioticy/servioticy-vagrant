#!/bin/bash

echo "CREATE DATABASE composeidentity2" | mysql -uroot -proot &> /dev/null
echo "CREATE DATABASE uaadb" | mysql -uroot -proot &> /dev/null
echo "GRANT ALL ON *.* TO 'root'@'localhost'" | mysql -uroot -proot &> /dev/null
echo "flush privileges" | mysql -uroot -proot &> /dev/null