# Review of Global ALBs in GCP and Migrating Regional ALB to Global ALB with Terraform

## Table of Contents

- [Documentation Links](#documentation-links)
- [Architecture Diagrams](#architecture-diagrams)
- [Global LB Test Script](#global-lb-test-script)
- [Naming Convention](#naming-convention)
- [Resources Change List](#resources-change-list)
- [Conclusion](#conclusion)

---

## Documentation Links

- [Global External Application LB](https://cloud.google.com/load-balancing/docs/https/setup-global-ext-https-compute)
- [Cloud Skills Boost Lab](https://www.cloudskillsboost.google/focuses/1232?catalog_rank=%7B%22rank%22%3A2%2C%22num_filters%22%3A0%2C%22has_search%22%3Atrue%7D&parent=catalog&search_id=44407083)
- [Deep Dive into Global LB](https://cloud.google.com/blog/topics/developers-practitioners/google-cloud-global-external-https-load-balancer-deep-dive)

---

## Architecture Diagrams

![](https://github.com/aaron-dm-mcdonald/class6.5-notes/blob/main/060325/assets/console-to-tf-map.PNG)  
![](https://github.com/aaron-dm-mcdonald/class6.5-notes/blob/main/060325/assets/GCP%2BGlobal%2BLB%2Bcomponents.png)  
![](https://github.com/aaron-dm-mcdonald/class6.5-notes/blob/main/060325/assets/global-lb-v2.svg)

---

## Global LB Test Script

- [Old test script README](../041925/README.md)

To run a new load test against the Global LB:

```bash
pip install locust

locust -f <locustfile.py location> --headless -u 100 -r 10 --host http://<LB IP ADDRESS>

```


---

## Naming Convention

To maintain clarity and scalability, the following naming conventions are used:

1. **Global resources** are named or prefixed with `app` or `lb`.
2. **Regional resources** are named or prefixed with `region_a` or `region_b`.
3. **Terraform files** for regional resources are segmented by suffixes:
   - Files specific to Region A use the suffix `a` (e.g., `9a-mig.tf`)
   - Files specific to Region B use the suffix `b` (e.g., `9b-mig.tf`)

---

## Resources Change List

### `variables.tf`
- Defined simple string-type variables:
  - `region_a`: the first region
  - `subnet_a_cidr`: CIDR block for Region A subnet
  - `region_b`: the second region
  - `subnet_b_cidr`: CIDR block for Region B subnet
  - `app_name`: application name
- These are generally used in `name` arguments for consistency.

---

### `3-subnets.tf`
- Removed the proxy-only subnet.
- Added a new subnet in Region B.

---

### `4-router.tf`
- Added an additional router for Region B.
- Split into:
  - `4a-router.tf` (Region A)
  - `4b-router.tf` (Region B)

---

### `5-nat.tf`
- Added NAT gateway and static IP address for Region B.
- Split into:
  - `5a-nat.tf` (Region A)
  - `5b-nat.tf` (Region B)

---

### `7a-compute.tf`
- Removed entirely, as the standalone VM demo is no longer needed.

---

### `7b-template.tf`
- Added separate instance templates for each region.
- Each template uses a unique startup script.
- Renamed to:
  - `7a-template.tf` (Region A)
  - `7b-template.tf` (Region B)

---

### `8-health-check.tf`
- Updated the resource type:
  - From `google_compute_region_health_check`
  - To `google_compute_health_check` (global)
- No changes to configuration parameters.
- Now scoped globally so both MIGs can share it.

---

### `9-mig.tf`
- Added a new Managed Instance Group for Region B.
- Split into:
  - `9a-mig.tf` (Region A)
  - `9b-mig.tf` (Region B)

---

### `10-autoscale-policy.tf`
- Added autoscaling policy for Region B.
- Split into:
  - `10a-autoscale-policy.tf` (Region A)
  - `10b-autoscale-policy.tf` (Region B)

---

### `11-lb-backend.tf`
- Backend service now references the global health check.
- Added an additional backend for Region B in `google_compute_backend_service`.

---

### `12-lb-frontend.tf`
- All frontend resources updated for global scope:
  - `google_compute_address` ➜ `google_compute_global_address`
  - `google_compute_region_url_map` ➜ `google_compute_url_map`
  - `google_compute_region_target_http_proxy` ➜ `google_compute_target_http_proxy`
  - `google_compute_forwarding_rule` ➜ `google_compute_global_forwarding_rule`
    - Removed `network` and `depends_on` arguments as they're not required for global resources.

---
