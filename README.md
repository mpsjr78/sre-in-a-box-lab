# 📦 SRE in a Box: A Local Reliability Engineering Lab

## 🎯 Overview
This repository contains a fully functional, local Site Reliability Engineering (SRE) laboratory. The goal of this project is to demonstrate end-to-end SRE practices, including Infrastructure as Code (IaC), microservices deployment, observability, chaos engineering, and incident response.

Instead of relying on managed cloud services, this environment is engineered to run entirely on a local machine with strict resource constraints (16GB RAM), showcasing architectural trade-offs, resource tuning, and cost-effective testing environments.

## 🏗️ Architecture & Technologies

* **Infrastructure:** Terraform, `k3d` (Lightweight Kubernetes)
* **Sample Application:** Yelb / Sock Shop (Lightweight microservices architecture)
* **Observability:** Prometheus, Grafana, Alertmanager (Kube-Prometheus-Stack)
* **Chaos Engineering:** Chaos Mesh
* **Documentation:** Blameless Post-Mortems in Markdown

## 🤔 Technical Decisions & Trade-offs
To ensure the entire stack runs smoothly on a standard developer machine (Intel i7, 16GB RAM) without incurring cloud provider costs (e.g., AWS EKS), the following decisions were made:
* **k3d over Minikube/Cloud:** `k3d` runs a highly available K3s cluster inside Docker containers, consuming significantly less memory than a full-blown Kubernetes distribution.
* **Resource Limits:** The observability stack (Prometheus/Grafana) has been aggressively tuned via Helm `values.yaml` to prevent out-of-memory (OOM) kills while still retaining enough metric history for local troubleshooting.

## 🚨 Incident Response & Chaos Scenarios
This lab is not just about building; it's about breaking and fixing. Below is the log of simulated incidents and their corresponding blameless post-mortems:

| Date | Incident Scenario | Tool Used | Post-Mortem Report | Status |
| :--- | :--- | :--- | :--- | :--- |
| YYYY-MM-DD | Database Pod Deletion (Hardware Failure Sim) | Chaos Mesh | [Read Report](./docs/post-mortems/01-database-outage.md) | 🟢 Resolved |
| YYYY-MM-DD | Network Latency Injection on Checkout | Chaos Mesh | [Read Report](./docs/post-mortems/02-network-latency.md) | 🚧 Planned |
| YYYY-MM-DD | CPU Stress on Worker Node | Chaos Mesh | [Read Report](./docs/post-mortems/03-cpu-stress.md) | 🚧 Planned |

## 🚀 How to Run This Lab Locally

### Prerequisites
* Docker
* Terraform
* `k3d` CLI
* `kubectl` and `helm`

### Step-by-Step
1. **Provision Infrastructure:**
   ```bash
   cd infrastructure
   terraform init
   terraform apply