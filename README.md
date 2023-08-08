# .dotfiles

## On a new system

* `git clone --bare https://github.com/tjadunn/.dotfiles.git $HOME/.dotfiles`
* `alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`
* `dotfiles checkout`
* `echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc`
* `dotfiles config --local status.showUntrackedFiles no`
