# Hadi's LazyVim Config

my nvim config, i keep public to do easy pulls into any remote box, you are free to use. Tested on various macos/linux distros.

# Setup

cd into `~/.config` on your machine, usually this works :

```
cd
cd .config
```

then clone the repo (ssh keys on the machine not needed it's public)

```
git clone git@github.com:alsibassi/nvim.git
```

your nvim will now find ``~.config/nvim`` as its nvim



run nvim to get the initial setup

```
nvim
```

and watch the config auto set up everything. After the setup is done I like to press Clean, then Sync, then quit the Lazy buffer, and quit the whole nvim window with :qa!, it seems to hang after the first setup if you don't quit the window.

If you are trying to use the config on a linux box, make sure to execute the linux setup script first :

```
cd
cd .config
chmod +x setup.sh
./setup.sh
```

# Requirements
You need the new nvim at least 0.12, make sure your box/setup has it before you set up (it will just tell you your nvim is outdated and won't run the setup)
