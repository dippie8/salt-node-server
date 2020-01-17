{%- if grains['os_family'] in ['Ubuntu', 'Debian'] %}

nodejs.ppa:
  pkg.installed:
    - name: apt-transport-https
    - require_in:
      - pkgrepo: nodejs.ppa

  pkgrepo.managed:
    - humanname: NodeSource Node.js Repository
    - name: deb {{ salt['pillar.get']('node:ppa:repository_url', 'https://deb.nodesource.com/node_12.x') }} {{ grains['oscodename'] }} main
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/nodesource.list
    - keyid: "68576280"
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: nodejs
{%- endif %}

{%- if grains['os_family'] in ['RedHat'] %}
nodejs.ppa:
  cmd.run:
    - name: curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
{%- endif %}

nodejs:
  pkg.installed:
    - name:  {{ salt['pillar.get']('node:node_pkg', 'nodejs') }}
    - reload_modules: true
{%- if salt['pillar.get']('node:version', '') and grains['os_family'] in ['Ubuntu', 'Debian'] %}
    - version: {{ salt['pillar.get']('node:version', '') }}
{%- endif %}