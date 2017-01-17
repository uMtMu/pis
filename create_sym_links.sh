#!/bin/bash

dotfiles=$(ls $(pwd)/dotfiles)
for file in $dotfiles
do
    if $file=="i3config"
    then
        mkdir "$HOME/i3"
        ln -s "$(pwd)/dotfiles/$file" "$HOME/.i3/config"
    else
        ln -s "$(pwd)/dotfiles/$file" "$HOME/.$file"
    fi
done

echo "source ~/.alias" >> ~/.bashrc

ln -s "$(pwd)/bg_rnd.sh" "$HOME/.bg_rnd.sh"

