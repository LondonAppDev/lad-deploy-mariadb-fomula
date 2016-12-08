{% from "mariadb/map.jinja" import mariadb with context %}

common_mariadb_repo_installed:
    pkgrepo.managed:
        - humanname: MariaDB10.1 Repository
        {% if grains['os'] == 'Ubuntu' %}
        - name: deb [arch=amd64,i386,ppc64el] http://lon1.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main
        - keyid: '0xF1656F24C74CD1D8'
        - keyserver: keyserver.ubuntu.com
        {% else %}
        - name: deb [arch=amd64,i386] http://lon1.mirrors.digitalocean.com/mariadb/repo/10.1/debian jessie main
        - keyid: '0xcbcb082a1bb943db'
        - keyserver: keyserver.ubuntu.com
        {% endif %}
        - file: /etc/apt/sources.list.d/MariaDB.list
        - refresh_db: True

mariadb-server:
    debconf.set:
        - name: mariadb-server
        - data:
            'mysql-server/root_password': {'type': 'string', 'value': '{{ mariadb.root_password }}'}
            'mysql-server/root_password_again': {'type': 'string', 'value': '{{ mariadb.root_password }}'}
    pkg.installed:
        - require:
            - pkgrepo: common_mariadb_repo_installed
    service.running:
        - name: mysql
        - eanble: True
