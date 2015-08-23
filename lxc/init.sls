{%- macro create_and_config_n(name,type,ver,args={},num=None) %}
{%- if args['create'] is defined and args['create'] == True %}
{{ name  | replace('%X%', num) }}_create:
cmd.run:
  - name: lxc-create -t {{type}} -n {{name | replace('%X%', num) }} -- -r {{ver}}
{%- endif  %}
{{ name | replace('%X%', num) }}_config:
file.managed:
  - name: /var/lib/lxc/{{name | replace('%X%', num)}}/config
  - source: salt://lxc/templates/config
  - template: jinja
{%- endmacro -%}

{% macro create_and_config(name,type,ver,args={}) -%}
{%- if args['x_start'] is defined %}
{%- for x_num in range(args['x_start'],args['x_start']+args['x_number']) %}
  {{ create_and_config_n(name,type,ver,args=args,num=x_num) }}
{%- endfor -%}
{%- else %}
  {{ create_and_config_n(name,type,ver,args=args) }}
{%- endif %}
{%- endmacro %}

{%- if pillar['lxc']['debian'] is defined or pillar['lxc']['ubuntu'] is defined %}
# installing debootstrap if needed
install_debootstrap:
  pkg.installed:
    - name: debootstrap
{%- endif %}

# containers installation & config
{%- for type,versions in pillar['lxc'].items() %}
{%- if type in ['debian','ubuntu'] %}{% set debootstrap = True %}{%- endif -%}
{%- for ver,names in versions.items() %}
{%- for name,args in names.items() %}
  {%- if args['args'] is defined %}
    {{ create_and_config(name,type,ver,args=args['args']) }}
  {%- else -%}
    {{ create_and_config(name,type,ver) }}
  {%- endif -%}
{%- endfor -%}
{%- endfor -%}
{%- endfor -%}
