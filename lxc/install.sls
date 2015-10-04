
install_lxc:
    pkg.installed:
        - name: lxc

# installing debootstrap if needed
{%- if pillar['lxc']['debian'] is defined or pillar['lxc']['ubuntu'] is defined %}
install_debootstrap:
  pkg.installed:
    - name: debootstrap
{% endif %}
