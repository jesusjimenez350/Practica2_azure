variable "vm_size_master_nfs" {
  type = string
  description = "Tamaño de la máquina virtual de master y nfs"
  default = "Standard_D2_v2" # 7 GB, 2 CPU 
}

variable "vm_size_workers" {
  type = string
  description = "Tamaño de las máquinas virtuales de los workes"
  default = "Standard_D1_v2" # 3.5 GB, 1 CPU 
}

variable "vm_workers" {
  type = list(string)
  description = "Listado de las máquinas virtuales de los workers"
  default = ["worker1", "worker2"]
}