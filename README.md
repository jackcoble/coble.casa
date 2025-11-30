# coble.casa 🏠

This repository contains all of the configuration for my homelab. The idea is for my setup to be reproducable and use open source tools such as OpenTofu, Ansible and Kubernetes to automate as much of it as possible.

* [OpenTofu](https://opentofu.org) - create and manage VMs on my Proxmox host
* [Ansible](https://docs.ansible.com/) - provision the VMs with the tools I need
* [Kubernetes](https://kubernetes.io/) - container orchestration on those VMs

## Hardware

I operate this lab on a single machine. It's not highly available, and that is fine. I bought a Lenovo M920q Mini PC back in March, and fitted it out with some extra storage and RAM:

* CPU: Intel Core i5-8500T (6 cores)
* RAM: 64GB Crucial DDR4 @ 3200MHz
* SSD: 1TB Crucial P2 CT1000P2SSD8 NVMe

I do also have a HBA card hooked up to this machine, that provides me with 12TB of raw storage capacity, or 3TB usable (ZFS Mirror as they are all used drives).

## Software

This is the software which is essentially the backbone of my lab.

### Proxmox VE

The base OS for my machine is [Proxmox VE](https://www.proxmox.com/en/). It's been great for me in a lab environment where I can spin up LXC containers and VMs with very minimal overhead.

### TrueNAS CE (VM)

The bulk of my data is stored on a TrueNAS VM, with the HBA card passed through to the VM. I know there is a stigma about virtualising your storage appliance, but it has been working flawlessly for me.

## Todo
[x] OpenTofu to provision Rocky Linux VMs with Cloud-Init
[ ] Ansible to bootstrap VMs with Kubernetes
[ ] Kubernetes deployment manifests, Flux CD, etc