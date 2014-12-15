Installation:

    git clone git://github.com/bartels/vimconfig.git  ~/.vim
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc


Vim plugins are installed as git submodules, and loaded using [pathogen](https://github.com/tpope/vim-pathogen) from the 'bundle' directory.  
To get them, issue the following commands:

    git submodule init
    git submodule update
