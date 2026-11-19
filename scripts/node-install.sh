#!/usr/bin/env bash
set -euo pipefail

# install marzban-node on new/clean server

log()  { echo -e "\e[32m[+]\e[0m $*"; }
fail() { echo -e "\e[31m[x]\e[0m $*" >&2; exit 1; }

check_root() {
    [[ $EUID -eq 0 ]] || fail "Зайди под root"
}

setup_firewall() {
    local panel_ip

    read -rp "Введите IP панели Marzban: " panel_ip
    [[ -n "$panel_ip" ]] || fail "IP не указан"

    log "Открытие OpenSSH, 443"
    ufw allow OpenSSH
    ufw allow 443/tcp

    log "Открытие 62050, 62061 портов для главной ноды"
    ufw allow from "$panel_ip" to any port 62050:62051 proto tcp

    log "Включение firewall"
    ufw --force enable
}

node_install() {
    local node_name

    read -rp "Введите название ноды (default): marzban-node" node_name
    node_name="${node_name:-marzban-node}"

    sudo bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban-node.sh)" @ install --name  "$node_name"
}

main() {
    check_root
    setup_firewall
    node_install
}

main "$@"
