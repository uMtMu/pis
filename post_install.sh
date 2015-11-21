#! /bin/bash
# 140101 uMt

# Ubuntu güncellemelerini yükle
./update.sh

sudo apt-get update
sudo apt-get upgrade -y -q



# Setups siniflara ayrilablir
uygulamalar=('build-essential' 'python-dev' 'default-jdk' 'terminator' 'guake' 'chromium-browser' 'pepperflashplugin-nonfree' 'bpython' 'mutt' 'w3m' 'newsbauter' 'wget' 'mc' 'mpg123')

yukle_apt(){
  sudo apt-get install -y -q $1
}

cok_yukle(){
  # Disaridan gelen dizinin içeride kullanılması
  # http://stackoverflow.com/questions/1063347/passing-arrays-as-parameters-in-bash
  declare -a uygulama_listesi=("${!1}")
  # Dizi üzerinde gezinme
  # http://www.cyberciti.biz/faq/bash-for-loop-array/
  for i in "${uygulama_listesi[@]}"
    do
      yukle_apt $i
    done
}

# Dongu ile uygulamalari kur
# Dizinin parametre olarak gönderilmesi
cok_yukle uygulamalar[@]
update-pepperflashplugin-nonfree --install

yukle_apt "rtorrent"
mkdir ~/rDownloads
mkdir ~/rSession
cat rtorrent.rc > ~/.rtorrent.rc

# Bash alias
cat bash_alias.txt >> /etc/bash.bashrc

# Vim, vimrc
yukle_apt "vim"
cat vim.txt >> /usr/share/.vimrc

i3wm=("i3wm" "i3lock" "i3status")
cok_yukle i3wm[@]
# i3wm, i3config
# ÖZELLİKLE ÜSTÜNE YAZIYORUM
cat i3config.txt > ~/.i3/config


git=("git" "git-flow")
cok_yukle git[@]
# Git, git config
./git.sh

# easy_install ve pip kurulacak
# varsayılan python sürümü için yükler
yukle_apt "easy_install"
yukle_apt "python-pip"

# Python ide
# indir
# aç
# wget http://download.jetbrains.com/python/pycharm-community-3.4.1.tar.gz
# tar xzf pycharm-community-3.4.1.tar.gz 
# mv pycharm-community-3.4.1 ~/.
# rm pycharm-community-3.4.1.tar.gz 

wget -q -O - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
sudo sh -c 'echo "deb http://archive.getdeb.net/ubuntu trusty-getdeb apps" >> /etc/apt/sources.list.d/getdeb.list'
sudo apt-get update
yukle_apt pycharm

# Eclipse java ide
# indir
# aç
# wget https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz
# tar xzf eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz
# mv eclipse-java-luna-SR1-linux-gtk-x86_64 ~/.
# rm eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz
