# installing debootstrap if needed
install_debootstrap:
  pkg.installed:
    - name: debootstrap
