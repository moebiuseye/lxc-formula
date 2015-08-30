
install_lxc:
  pkg.instaled:
    - name: lxc

include:
{%- if pillar['lxc']['debian'] is defined or pillar['lxc']['ubuntu'] is defined %}
  - lxc.install
{% endif %}
  - lxc.config
