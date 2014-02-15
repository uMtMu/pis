# 140101 uMt

# Bash alias
cat bash_alias.txt >> /etc/bash.bashrc

# Setups siniflara ayrilablir
uygulamalar=('build-essential' 'mutt' 'w3m' 'newsbauter')

yukle(){
  sudo apt-get install -y -q $1
}

# Dongu ile uygulamalari kur

# Vim, vimrc
yukle("vim")
cat vim_settings.txt >> /usr/share/.vimrc

git=("git" "git-flow")
# Dongu ile giti kur
# Git, git config
./git.sh

# easy_install ve pip kurulacak
# Python ide
# indir
# kur


# Java & Scale environment, ide
# eclipse?