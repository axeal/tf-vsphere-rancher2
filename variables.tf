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

variable "vsphere_cdrom_path" {
  default = ""
}

variable "rancher_cpus" {
  default = 2
}

variable "rancher_memory" {
  default = 2048
}

variable "rancher_disk_size" {
  default = 20
}

variable "agent_cpus" {
  default = 2
}

variable "agent_memory" {
  default = 2048
}

variable "agent_disk_size" {
  default = 20
}

variable "prefix" {
  default = ""
}

variable "rancher_version" {
  default = "v2.4.3"
}

variable "rancher_args" {
  default = ""
}

variable "audit_level" {
  default = 0
}

variable "admin_password" {
  default = "admin"
}

variable "k8s_version" {
  default = ""
}

variable "cluster_name" {
  default = "custom"
}

variable "ssh_keys" {
  default = []
}

variable "count_agent_all_nodes" {
  default = "0"
}

variable "count_agent_etcd_nodes" {
  default = "0"
}

variable "count_agent_controlplane_nodes" {
  default = "0"
}

variable "count_agent_worker_nodes" {
  default = "0"
}
