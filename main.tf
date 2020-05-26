provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

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

resource "vsphere_virtual_machine" "rancherserver" {
  name             = "${var.prefix}-rancherserver"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.rancher_cpus
  memory   = var.rancher_memory
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
    size             = var.rancher_disk_size
    eagerly_scrub    = "false"
    thin_provisioned = "true"
  }

  extra_config = {
    "guestinfo.cloud-init.config.data"   = base64encode(templatefile("files/cloud_config_server", {
      admin_password        = var.admin_password,
      audit_level           = var.audit_level,
      rancher_version       = var.rancher_version,
      rancher_args          = var.rancher_args,
      ssh_keys              = var.ssh_keys,
      hostname              = "${var.prefix}-rancherserver",
      vsphere_server        = var.vsphere_server,
      vsphere_user          = var.vsphere_user,
      vsphere_password      = var.vsphere_password,
      k8s_version           = var.k8s_version,
      cluster_name          = var.cluster_name,
      vsphere_server        = var.vsphere_server,
      vsphere_user          = var.vsphere_user,
      vsphere_password      = var.vsphere_password,
      vsphere_datacenter    = var.vsphere_datacenter,
      vsphere_datastore     = var.vsphere_datastore,
      vsphere_resource_pool = var.vsphere_resource_pool
    }))
    "guestinfo.cloud-init.data.encoding" = "base64"
  }
}

resource "vsphere_virtual_machine" "rancheragent-all" {
  count            = var.count_agent_all_nodes
  name             = "${var.prefix}-rancheragent-all-${count.index}"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.agent_cpus
  memory   = var.agent_memory
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
    size             = var.agent_disk_size
    eagerly_scrub    = "false"
    thin_provisioned = "true"
  }

  extra_config = {
    "guestinfo.cloud-init.config.data" = base64encode(templatefile("files/cloud_config_agent", {
      ssh_keys        = var.ssh_keys,
      hostname        = "${var.prefix}-rancheragent-all-${count.index}",
      rancher_version = var.rancher_version,
      cluster_name    = var.cluster_name,
      server_address  = vsphere_virtual_machine.rancherserver.default_ip_address
      admin_password  = var.admin_password
    }))
    "guestinfo.cloud-init.data.encoding" = "base64"
  }
}

resource "vsphere_virtual_machine" "rancheragent-etcd" {
  count            = var.count_agent_etcd_nodes
  name             = "${var.prefix}-rancheragent-etcd-${count.index}"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.agent_cpus
  memory   = var.agent_memory
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
    size             = var.agent_disk_size
    eagerly_scrub    = "false"
    thin_provisioned = "true"
  }

  extra_config = {
    "guestinfo.cloud-init.config.data" = base64encode(templatefile("files/cloud_config_agent", {
      ssh_keys        = var.ssh_keys,
      hostname        = "${var.prefix}-rancheragent-etcd-${count.index}",
      rancher_version = var.rancher_version,
      cluster_name    = var.cluster_name,
      server_address  = vsphere_virtual_machine.rancherserver.default_ip_address
      admin_password  = var.admin_password
    }))
    "guestinfo.cloud-init.data.encoding" = "base64"
  }
}

resource "vsphere_virtual_machine" "rancheragent-controlplane" {
  count            = var.count_agent_controlplane_nodes
  name             = "${var.prefix}-rancheragent-controlplane-${count.index}"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.agent_cpus
  memory   = var.agent_memory
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
    size             = var.agent_disk_size
    eagerly_scrub    = "false"
    thin_provisioned = "true"
  }

  extra_config = {
    "guestinfo.cloud-init.config.data" = base64encode(templatefile("files/cloud_config_agent", {
      ssh_keys        = var.ssh_keys,
      hostname        = "${var.prefix}-rancheragent-controlplane-${count.index}",
      rancher_version = var.rancher_version,
      cluster_name    = var.cluster_name,
      server_address  = vsphere_virtual_machine.rancherserver.default_ip_address
      admin_password  = var.admin_password
    }))
    "guestinfo.cloud-init.data.encoding" = "base64"
  }
}

resource "vsphere_virtual_machine" "rancheragent-worker" {
  count            = var.count_agent_worker_nodes
  name             = "${var.prefix}-rancheragent-worker-${count.index}"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.agent_cpus
  memory   = var.agent_memory
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
    size             = var.agent_disk_size
    eagerly_scrub    = "false"
    thin_provisioned = "true"
  }

  extra_config = {
    "guestinfo.cloud-init.config.data" = base64encode(templatefile("files/cloud_config_agent", {
      ssh_keys        = var.ssh_keys,
      hostname        = "${var.prefix}-rancheragent-worker-${count.index}",
      rancher_version = var.rancher_version,
      cluster_name    = var.cluster_name,
      server_address  = vsphere_virtual_machine.rancherserver.default_ip_address
      admin_password  = var.admin_password
    }))
    "guestinfo.cloud-init.data.encoding" = "base64"
  }
}

resource "local_file" "ssh_config" {
  content = templatefile("${path.module}/files/ssh_config_template", {
    prefix                    = var.prefix
    rancherserver             = vsphere_virtual_machine.rancherserver.default_ip_address
    rancheragent-all          = [for node in vsphere_virtual_machine.rancheragent-all : node.default_ip_address],
    rancheragent-etcd         = [for node in vsphere_virtual_machine.rancheragent-etcd : node.default_ip_address],
    rancheragent-controlplane = [for node in vsphere_virtual_machine.rancheragent-controlplane : node.default_ip_address],
    rancheragent-worker       = [for node in vsphere_virtual_machine.rancheragent-worker : node.default_ip_address],
  })
  filename = "${path.module}/ssh_config"
}

output "rancher-url" {
  value = ["https://${vsphere_virtual_machine.rancherserver.default_ip_address}"]
}
