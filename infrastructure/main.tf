terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

# 1. Create the optimized k3d configuration file
resource "local_file" "k3d_config" {
  filename = "${path.module}/k3d-config.yaml"
  content  = <<-EOT
    apiVersion: k3d.io/v1alpha5
    kind: Simple
    metadata:
      name: sre-cluster
    servers: 1
    agents: 1 # An extra worker node to simulate a distributed environment
    image: rancher/k3s:v1.31.5-k3s1
    ports:
      - port: 8080:80
        nodeFilters:
          - loadbalancer
  EOT
}

# 2. Orchestrate cluster creation and destruction
resource "null_resource" "k3d_cluster" {
  depends_on = [local_file.k3d_config]

  # Trigger to create the cluster via k3d CLI
  provisioner "local-exec" {
    command = "k3d cluster create --config ${path.module}/k3d-config.yaml"
  }

  # Trigger to destroy the cluster when running 'terraform destroy'
  provisioner "local-exec" {
    when    = destroy
    command = "k3d cluster delete sre-cluster"
  }
}
