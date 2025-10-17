Using the NFS server role

1. Add your NFS server host(s) to `ansible/inventory.ini` under the `[nfs]` group. Example:

   nfs-1 ansible_host=192.168.0.20

2. Customize exported path and allowed networks by creating `group_vars/nfs.yml` or host_vars for the host. Example `ansible/group_vars/nfs.yml`:

```yaml
nfs_export_path: /srv/nfs/k8s
nfs_allowed_networks:
  - 192.168.0.0/24
# or a single host
#  - 192.168.0.10(rw,sync,no_subtree_check)
```

3. Run the playbook:

```bash
ansible-playbook -i ansible/inventory.ini ansible/site.yml --limit nfs
```

4. Use the exported path in Kubernetes. For dynamic provisioning, install an NFS provisioner (example: nfs-subdir-external-provisioner) in the cluster and point it at `nfs-1:/srv/nfs/k8s`.

Notes:
- The role supports Debian and RedHat families.
- `nfs_export_options` defaults to `rw,sync,no_subtree_check,no_root_squash`. Adjust as needed.
