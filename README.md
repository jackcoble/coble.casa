# coble.casa 🏠

This repository contains all of the configuration for my homelab. The idea is for my setup to be reproducable and use open source tools such as Proxmox, OpenTofu and Ansible.

* [Proxmox VE 9.1](https://www.proxmox.com/en/) - my hypervisor of choice
* [OpenTofu](https://opentofu.org) - create and manage VMs on my Proxmox host
* [Ansible](https://docs.ansible.com/) - bootstrap VMs with their applications

## Hardware 🛠️

I operate this lab on a single machine. It's not highly available, and that is fine. I bought a Lenovo M920q Mini PC back in March, and upgraded the storage and RAM:

* CPU: Intel Core i5-8500T (6 cores)
* RAM: 64GB Crucial DDR4 @ 3200MHz
* SSD: 1TB Crucial P2 CT1000P2SSD8 NVMe
* HBA: LSI 9200-8e HP SAS HBA
* HDDs: A combination of Seagate Desktop and Ironwolf disks, of the same size (3TB)

## Software ⚙️

This is the software which is essentially the backbone of my lab.

### Proxmox VE

The base OS for my machine is Proxmox VE 9.0. I like having the ability to create/spin up VMs and containers on demand, before I look at bringing the configuration into OpenTofu. It also works well with [Proxmox Backup Server (PBS)](https://www.proxmox.com/en/products/proxmox-backup-server/overview), which I have running separately on a Beelink S12 Pro NUC.

Proxmox is powerful as it exposes an API for users to interact with; paired with the awesome OpenTofu provider [bpg/proxmox](https://github.com/bpg/terraform-provider-proxmox), it allows me to use OpenTofu to manage all of my resource declaratively!

### TrueNAS CE (VM)

The bulk of my data is stored on a virtualised TrueNAS server, with the HBA card passed through directly to the VM. I mostly wanted to take advantage of ZFS and the features it has to offer, such as snapshots. It's certainly overkill for what I currently use it for (serving directories via SMB and NFS).

## Deploying 🚀

### Infrastructure

Let's start with provisioning VMs.

```bash
$ cd opentofu/
$ tofu apply
```

I'll get a coffee whilst that provisions all the VMs.

### Services

#### Tailscale & DNS

The most important VM is Tailscale, as that is our "entrypoint" into the network, and also our DNS server!

```bash
$ cd ansible/
$ ansible-playbook playbooks/setup-tailscale-dns.yml
```