#!/bin/bash
dotfiles=$(ls $(pwd)/dotfiles)
for file in $dotfiles
do
    ln -s "$(pwd)/dotfiles/$file" "$HOME/.$file"
done
