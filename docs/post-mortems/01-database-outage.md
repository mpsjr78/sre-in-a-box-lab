# Incident Report: Simulated Database Pod Failure

## 📅 Incident Details
* **Date:** 2026-02-20
* **Status:** 🟢 Resolved
* **Incident Commander:** SRE Team

## 📝 Summary
At approximately 20:53, a simulated hardware/container failure was injected into the production-like environment targeting the `yelb-db` (PostgreSQL) pod. The goal of this Chaos Engineering experiment was to validate the observability stack's alerting responsiveness and the Kubernetes cluster's self-healing capabilities.

## 💥 Impact
* **User Impact:** Users experienced a brief inability to cast votes on the Yelb UI for approximately 5 to 10 seconds. Existing cached data via Redis remained accessible.
* **System Impact:** Complete loss of the primary database pod (`yelb-db-699447c8fd-rsj7x`).

## 🔍 Root Cause
Intentional chaos injection using **Chaos Mesh**. A `PodChaos` action (`pod-kill`) was executed against the label selector `app: yelb-db` to simulate a sudden node crash or OOMKill event.

## 🛠️ Resolution & Recovery
The system functioned exactly as designed. 
1. The Kubernetes Deployment controller immediately detected that the desired state (1 replica of `yelb-db`) did not match the actual state (0 replicas).
2. A new pod (`yelb-db-699447c8fd-pgk7f`) was automatically provisioned and scheduled.
3. Once the new pod achieved a `Running` state, the Traefik Ingress controller re-established the internal routing, and the application fully recovered without manual human intervention.
4. Grafana metrics accurately captured the drop in CPU/Memory for the terminated pod and the spike for the newly provisioned one.

## 📋 Action Items (Continuous Improvement)
To further improve reliability and move towards "Zero Downtime" during database pod failures, the following architectural improvements should be considered:
1. **[ ] Implement Database High Availability (HA):** Migrate from a single-pod PostgreSQL deployment to a multi-node cluster (Primary/Replica) using an operator like CloudNativePG.
2. **[ ] Liveness/Readiness Probes Tuning:** Ensure the Kubernetes probes are aggressively tuned to stop routing traffic to a failing database even before the pod completely dies.
