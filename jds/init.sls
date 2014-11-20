include:
  - sudoers

vim:
  pkg.installed

zsh:
  pkg.installed

tmux:
  pkg.installed

git:
  pkg.installed

emacs:
  pkg.installed

jds:
  user.present:
    - home: /home/jds
    - password: $6$fihDz2vX$P0KhbDKaUI0wD2l/iTNSdcyjttqMHKw7pA3.6HU.oXeQ3vQ1786Cnp2MrgrK8noLk66WX5w.tBqc.bjC0eFn20
    - shell: /bin/zsh
    - gid_from_name: True
    - require:
      - file: /home/jds
      - pkg: zsh
      - sls: sudoers

/home/jds/.tmux.conf:
  file.managed:
    - user: jds
    - group: jds
    - mode: 0600
    - source: salt://jds/tmux.conf
    - require:
      - user: jds

/home/jds/.emacs.d/init.el:
  file.managed:
    - user: jds
    - group: jds
    - mode: 0600
    - source: salt://jds/emacs.d/init.el
    - require:
      - user: jds
      - file: /home/jds/.emacs.d

/home/jds:
  file.directory:
    - user: jds
    - group: jds
    - mode: 0700

/home/jds/.emacs.d:
  file.directory:
    - user: jds
    - group: jds
    - mode: 0700

/home/jds/.ssh:
  file.directory:
    - user: jds
    - group: jds
    - mode: 0700

/home/jds/.gitconfig:
  file.managed:
    - user: jds
    - group: jds
    - mode: 0600
    - source: salt://jds/gitconfig
    - require:
      - user: jds
      - pkg: git

/home/jds/.zshrc:
  file.managed:
    - user: jds
    - group: jds
    - mode: 0600
    - source: salt://jds/zshrc
    - require:
      - user: jds
      - pkg: zsh
      - pkg: git

https://github.com/johnswanson/oh-my-zsh:
  git.latest:
    - rev: master
    - target: /home/jds/.oh-my-zsh
    - force: True
    - require:
      - user: jds
      - pkg: git
      - pkg: zsh

/home/jds/.vimrc:
  file.managed:
    - user: jds
    - group: jds
    - mode: 0600
    - source: salt://jds/vimrc
    - require:
      - user: jds
      - pkg: vim

sshkeys:
  ssh_auth:
    - present
    - user: jds
    - enc: ssh-rsa
    - source: salt://jds/id_rsa.pub
