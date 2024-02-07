terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.25.2"
    }
  }
}