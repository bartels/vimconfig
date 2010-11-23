Installation

    git clone git://github.com/bartels/vimconfig.git  ~/.vim
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc


Vim plugins are installed as git submodules.  To get them, issue the following commands:

    git submodule init
    git submodule update


The command-t extension requires vim to have ruby support build in. 
Use the following commands to compile the ruby extension:

    cd bundles/command-t/
    rake make 

