variable "vsphere_user" {
  default = ""
}

variable "vsphere_password" {
  default = ""
}

variable "vsphere_server" {
  default = ""
}

variable "vsphere_datacenter" {
  default = ""
}

variable "vsphere_datastore" {
  default = ""
}

variable "vsphere_resource_pool" {
  default = ""
}

variable "vsphere_network" {
  default = ""
}

variable "vsphere_vm_name" {
  default = ""
}

variable "vsphere_cdrom_path" {
  default = ""
}

variable "vsphere_cpus" {
  default = 2
}

variable "vsphere_memory" {
  default = 2048
}

variable "vsphere_disk_size" {
  default = 20
}

variable "rancher_version" {
  default = "v2.3.3"
}

variable "rancher_args" {
  default = ""
}

variable "admin_password" {
  default = "admin"
}

variable "ssh_keys" {
  default = []
}


provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "resource_pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vsphere_vm_name
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vsphere_cpus
  memory   = var.vsphere_memory
  guest_id = "other3xLinux64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id
    path         = var.vsphere_cdrom_path
  }

  disk {
    label            = "disk0"
    size             = var.vsphere_disk_size
    eagerly_scrub    = "false"
    thin_provisioned = "true"
  }

  extra_config = {
    "guestinfo.cloud-init.config.data"   = base64encode(templatefile("files/cloud_config_server", {
      admin_password        = var.admin_password,
      rancher_version       = var.rancher_version,
      rancher_args          = var.rancher_args,
      ssh_keys              = var.ssh_keys
    }))
    "guestinfo.cloud-init.data.encoding" = "base64"
  }
}
