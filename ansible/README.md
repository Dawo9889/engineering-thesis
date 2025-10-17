# Ansible Load Balancer Setup

This directory contains only the Ansible configuration required to install and configure the HA load balancers (HAProxy + Keepalived).

## Assumptions
- Load balancer hosts IPs: `192.168.0.8` (lb-1) and `192.168.0.9` (lb-2)
- VIP: `192.168.0.10` (change in `group_vars/lb.yml` if needed)
- You want to balance TCP traffic (e.g. Kubernetes API on 6443) across control plane nodes at: `192.168.0.3`, `192.168.0.4`, `192.168.0.5`.
- Network interface for VRRP: `eth0` (override with `keepalived_interface` if different)

## Files
```
ansible/
  inventory.ini
  site.yml
  group_vars/
    lb.yml
  roles/
    haproxy/
      tasks/main.yml
      handlers/main.yml
      templates/haproxy.cfg.j2
    keepalived/
      defaults/main.yml
      tasks/main.yml
      handlers/main.yml
      templates/keepalived.conf.j2
```

## Usage
Quick usage
```
cd ansible_k3s
ansible-playbook -i inventory.ini site.yml --limit lb
```

Kept files and roles:
- `inventory.ini` — inventory with `lb` hosts
- `group_vars/lb.yml` — VIP, backend servers and HAProxy settings
- `roles/haproxy` — HAProxy role (tasks, handler, template)
- `roles/keepalived` — Keepalived role (defaults, tasks, template)
- `site.yml` — playbook targeting `lb` group

If you need the removed k3s installers back, restore them from git history.

## Security Notes
- Replace `keepalived_auth_pass` with a strong secret (store with `ansible-vault`).
- Avoid committing real passwords into version control.

## Changing the VIP
Update `virtual_ip` in `group_vars/lb.yml` and re-run the play. Keep it in the same subnet and unused by other hosts.

## Extending
- Add health check scripts for application-level checks.
- Add TLS termination in HAProxy frontend if required.
- Add firewall adjustments (e.g. with `ufw` or `firewalld`) if running.

## Clean Removal
To remove the configuration (not purge packages), you can delete the rendered files:
```bash
ansible -i inventory.ini lb -m file -a 'path=/etc/haproxy/haproxy.cfg state=absent'
ansible -i inventory.ini lb -m file -a 'path=/etc/keepalived/keepalived.conf state=absent'
```

## Troubleshooting
- Check HAProxy: `systemctl status haproxy` and `journalctl -u haproxy -e`
- Check Keepalived: `systemctl status keepalived` and `journalctl -u keepalived -e`
- See VRRP state: `ip a | grep 192.168.0.10`
- Packet capture VRRP: `tcpdump -ni eth0 vrrp`

---
Happy clustering!

Note: k3s-related installers and playbooks were removed from this directory. If you need them back, restore from git history.
