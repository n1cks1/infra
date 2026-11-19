#!/usr/bin/env bash

# install marzban-node on new/clean server


setup_firewall() {
    local panel_ip

    log "Открытие OpenSSH, 443"
    ufw allow OpenSSH
    ufw allow 443/tcp

    read -rp "Введите ip панели Marzban: " panel_ip
    log "Открытие 62050, 62061 портов для главной ноды"
    ufw allow from "$panel_ip" to any port 62050:62051 proto tcp
}

node_install() {
    local node_name

    read -rp "Введите название ноды (default): marzban-node" node_name
    node_name="${node_name:-marzban-node}"

    sudo bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban-node.sh)" @ install --name  "$node_name"
}

main() {
    setup_firewall
    node_install
}

main "$@"
