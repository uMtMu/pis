#!/bin/bash

echo "Güncelleme yapmak ister misiniz? [E/H]"
read cevap
if [ $cevap == "E" ]
then 
	sudo apt-get update
	sudo apt-get upgrade -y -q
else
	echo "Güncellemeler yapılmadı"
fi

