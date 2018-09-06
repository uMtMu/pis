#! /bin/bash
# 140101 uMt

# Ubuntu güncellemelerini yükle
./update.sh

# Setups siniflara ayrilablir
# programming
# build-essential python-dev default-jdk bpython
# terminal
# terminator quake mc
# internet
# chromium-browser pepperflashplugin-nonfree mutt w3m newsbauter wget
# media
# mpg123 feh(masa üstü arka planı için) 
#uygulamalar=('build-essential' 'python-dev' 'default-jdk' 'terminator' 'guake' 'chromium-browser' 'pepperflashplugin-nonfree' 'bpython' 'mutt' 'w3m' 'newsbauter' 'wget' 'mc' 'mpg123' 'feh')
uygulamalar=('build-essential' 'python-dev' 'terminator' 'mutt' 'w3m' 'newsbauter' 'wget' 'mc' 'mpg123' 'feh' 'silversearcher-ag' 'bash-completion' 'most')

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


# Vim, vimrc
yukle_apt "vim"

# Emacs
yukle_apt "emacs"

# i3
i3wm=('i3-wm' 'i3lock' 'i3blocks' 'kupfer')
cok_yukle i3wm[@]

#git
git=("git" "git-flow")
cok_yukle git[@]
# Git, git config
./git.sh

# easy_install ve pip kurulacak
# varsayılan python sürümü için yükler
yukle_apt "easy_install"
yukle_apt "python-pip"

./create_sym_links.sh

# history kayıtlarına tarih ekleme
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' | sudo tee -a /etc/bash.bashrc
