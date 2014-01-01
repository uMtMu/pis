#!/bin/bash

echo "Git de kullanmak istediğiniz eposta adresinizi giriniz"
read eposta
git config --global user.email $email
echo "Git de kullanmak istediğiniz kullanıcı adınızı giriniz"
read isim
git config --global user.name $isim
