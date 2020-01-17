node:
  version: 12.7.0-1nodesource1
  install_from_ppa: True
  node_pkg: nodejs
  ppa:
    repository_url: https://deb.nodesource.com/node_12.x

roles:
  - hwaas-web
