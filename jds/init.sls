vim:
  pkg.installed

zsh:
  pkg.installed

tmux:
  pkg.installed

jds:
  user.present:
    - home: /home/jds
    - shell: /bin/zsh
    - gid_from_name: True
    - require:
      - pkg: zsh

/home/jds/.tmux.conf:
  file.managed:
    - user: jds
    - group: jds
    - mode: 0600
    - source: salt://jds/tmux.conf
    - require:
      - user: jds

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

/home/jds/zshrc:
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
