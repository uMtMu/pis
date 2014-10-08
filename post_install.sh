# 140101 uMt

# Bash alias
cat bash_alias.txt >> /etc/bash.bashrc

# Setups siniflara ayrilablir
uygulamalar=('build-essential' 'python-dev' 'mutt' 'w3m' 'newsbauter' 'wget')

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
      yukle $i
    done
}

# Dongu ile uygulamalari kur
# Dizinin parametre olarak gönderilmesi
cok_yukle uygulamalar[@]


# Vim, vimrc
yukle_apt "vim"
cat vim_settings.txt >> /usr/share/.vimrc

git=("git" "git-flow")
cok_yukle git[@]
# Git, git config
./git.sh

# easy_install ve pip kurulacak
# varsayılan python sürümü için yükler
yukle_apt "easy_install"
yukle_apt "pip"

# Python ide
# indir
# kur
wget http://download.jetbrains.com/python/pycharm-community-3.4.1.tar.gz
tar xzf pycharm-community-3.4.1.tar.gz 

# Java & Scale environment, ide
# eclipse?
