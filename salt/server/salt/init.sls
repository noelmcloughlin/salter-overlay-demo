salt-cloud-digital-ocean-ssh-key:
  file.managed:
    - name: /etc/salt/pki/digital_ocean.pem
    - contents_pillar: user:ssh_keys:id_rsa
    - mode: 600
    - show_changes: False

salt-cloud-digital-ocean-provider:
  file.managed:
    - name: /etc/salt/cloud.providers.d/digital_ocean.sls
    - source: sls://server/salt/provider.sls
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - defaults:
        name: digital_ocean
        driver: digital_ocean
        token: {{ salt['pillar.get']('cloud_providers:digital_ocean:token') }}
        private_key: /etc/salt/pki/digital_ocean.pem
        salt_master: {{ salt['pillar.get']('salt-master:host') }}
    - require:
      - salt-cloud-digital-ocean-ssh-key
