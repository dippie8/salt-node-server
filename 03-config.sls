hwaas-user:
  user.present:
    - name: hwaas
    - home: /home/hwaas

hwaas-source:
  git.latest:
    - name: https://github.com/floyd-may/hwaas.git
    - rev: master
    - target: /home/hwaas/hwaas-site
    - require:
      - user: hwaas-user
      - pkg: git-client-package

hwaas-npm-reg:
  cmd.run:
    - name: npm config set registry="http://registry.npmjs.org/"
    - cwd: /home/hwaas/hwaas-site
    - require:
      - pkg: git-client-package

hwaas-npm-clean:
  cmd.run:
    - name: npm cache clean -f
    - cwd: /home/hwaas/hwaas-site
    - require:
      - pkg: git-client-package

hwaas-npm-install_0:
  cmd.run:
    - name: npm install -g n
    - cwd: /home/hwaas/hwaas-site
    - require:
      - pkg: git-client-package

hwaas-n-stable:
  cmd.run:
    - name: n stable
    - cwd: /home/hwaas/hwaas-site
    - require:
      - pkg: git-client-package

hwaas-npm-install:
  cmd.run:
    - name: npm install
    - cwd: /home/hwaas/hwaas-site
    - whatch:
      - git: hwaas-source

hwaas-build-script:
  cmd.run:
    - name: npm run-script build
    - cwd: /home/hwaas/hwaas-site
    - whatch:
      - git: hwaas-source

copy-service-file:
  file.managed:
    - name: /etc/systemd/system/node.service
    - source: salt://{{ slspath }}/archive/node.service 
    - require:
      - cmd: hwaas-build-script

start-service:
  service.running:
  - name: node
  - watch:
    - file: /etc/systemd/system/node.service
  - require:
    - file: copy-service-file