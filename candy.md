## totally useless, but feels so pimp

### bibata cursor:
https://www.gnome-look.org/p/1197198/  
https://github.com/KaizIqbal/Bibata_Cursor  
![](https://lh3.googleusercontent.com/-Zz9EldloYAQ/Wsj_V1kLoxI/AAAAAAAA29M/LoepoH-dmbcT1jEX-REE4bWA2oF9qsWDgCJoC/w1920-h1080/Bibata_ice_all.png)
set cursor size:  
`gsettings set org.gnome.desktop.interface cursor-size 32`

### crazy awesome shell:
https://medium.com/@alex285/get-powerlevel9k-the-most-cool-linux-shell-ever-1c38516b0caa  
![](https://cdn-images-1.medium.com/max/2560/1*dX9Y_QemiM4HU-slGgijtA.png)  

1. install zsh  
  `zypper in zsh`
2. install `oh-my-zsh` per github instructions  
  `git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh`  
2. copy included config file to home  
  `cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc`  
2. install PowerLevel9k  
  `git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/themes/powerlevel9k`  
2. set powerlevel9k as zsh_theme  
  `ZSH_THEME="powerlevel9k/powerlevel9k"`
2. edit as desired  
```
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="▶ "
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
```

#### colorls?
(prolly not, I don't think that I want an additional ls command)  
https://github.com/athityakumar/colorls  

