# Terraform config to launch Rancher 2

**Note: requires Terraform v0.12**

## Summary

This Terraform setup will:

- Start a VM running `rancher/rancher` version specified in `rancher_version`
- Add vSphere cloud credentials for creating vSphere node templates
- Create a custom cluster called `cluster_name` with the vSphere cloud provider enabled
- Start `count_agent_all_nodes` amount of VMs and add them to the custom cluster with all roles
- Create an ssh_config file in the terraform module directory for connecting to the VMs

### Optional adding nodes per role
- Start `count_agent_etcd_nodes` amount of droplets and add them to the custom cluster with etcd role
- Start `count_agent_controlplane_nodes` amount of droplets and add them to the custom cluster with controlplane role
- Start `count_agent_worker_nodes` amount of droplets and add them to the custom cluster with worker role

## Other options

All available options/variables are described in [terraform.tfvars.example](https://github.com/axeal/tf-vsphere-rancher2/blob/master/terraform.tfvars.example).

## SSH Config

**Note: set the appropriate users for the images in the terraform variables, default is `root`**

You can use the use the auto-generated ssh_config file to connect to the droplets by droplet name, e.g. `ssh <prefix>-rancheragent-0-all` or `ssh <prefix>-rancherserver` etc. To do so, you have two options:

1. Add an `Include` directive at the top of the SSH config file in your home directory (`~/.ssh/config`) to include the ssh_config file at the location you have checked out the this repository, e.g. `Include ~/git/tf-vsphere-rancher2/ssh_config`.

2. Specify the ssh_config file when invoking `ssh` via the `-F` option, e.g. `ssh -F ~/git/tf-vsphere-rancher2/ssh_config <host>`.

## How to use

- Clone this repository
- Ensure you have a copy of the RancherOS VMWare autoformat ISO in your vSphere datastore https://github.com/rancher/os/releases/latest/download/rancheros-vmware-autoformat.iso
- Move the file `terraform.tfvars.example` to `terraform.tfvars` and edit (see inline explanation)
- Run `terraform apply`
