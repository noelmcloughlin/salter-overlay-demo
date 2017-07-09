{% set os = grains['os']|lower %}
{% set codename = grains['lsb_distrib_codename'] %}

docker-group:
  group.present:
    - name: docker

docker-user:
  user.present:
    - name: docker
    - groups:
      - docker
      - users
    - createhome: True
    - fullname: Moby Dock
    - empty_password: True
    - require:
      - docker-group

docker-ppa:
  pkgrepo.managed:
    - humanname: Docker
    - name: deb https://apt.dockerproject.org/repo {{ os }}-{{ codename }} main
    - keyid: 58118E89F3A912897C070ADBF76221572C52609D
    - keyserver: p80.pool.sks-keyservers.net
    - file: /etc/apt/sources.list.d/docker.list

docker:
  pkg.installed:
    - pkgs:
      - docker
      - docker-engine
      {% if os == 'debian' %}
      - docker-compose
      {% endif %}
    - require:
      - docker-ppa

docker-service-file:
  file.managed:
    - name: /etc/systemd/system/docker.service.d/docker_user.conf
    - source: salt://linux/docker/docker_user.conf
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - require:
      - docker

docker-service-enabled:
  service.enabled:
    - name: docker

docker-service-running:
  service.running:
    - name: docker

{% if os == 'debian' %}
service.systemctl_reload:
  module.run:
    - onchanges:
      - file: /etc/systemd/system/docker.service.d/docker_user.conf
{% endif %}

minikube:
  file.managed:
    - comment: "Local Kubernetes Server"
    - name: /usr/local/bin/minikube
    - source: https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    - mode: 755
    - show_changes: False
    - skip_verify: True

docker-py:
  pip.installed

docker-gc:
  dockerng.image_present:
    - name: spotify/docker-gc
    - require:
      - docker-py

docker-cleanup:
  cron.present:
    - special: '@daily'
    - name: "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc:ro spotify/docker-gc"
    - require:
      - docker-gc