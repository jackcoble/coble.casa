# coble.casa

This repository contains all of the Ansible playbooks to *mostly* configure my homelab software.

## Secrets handling with SOPS

Secrets are stored in `secrets/secrets.yaml` and encrypted with [sops](https://github.com/getsops/sops).
The playbook uses the `community.sops` collection to decrypt this file on the
control machine. To install the collection run:

```bash
ansible-galaxy collection install community.sops
```

When `ansible-playbook` is executed, the secrets file is decrypted locally and
the values are injected into the tasks without requiring any keys on the target
hosts.
