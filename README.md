# Review of Global ALBs in GCP and migrating regional ALB to global ALB with terraform 

## Insert table of contents

## documentation links

- [Global External Application LB](https://cloud.google.com/load-balancing/docs/https/setup-global-ext-https-compute)
- [Cloud Skills Boost Lab](https://www.cloudskillsboost.google/focuses/1232?catalog_rank=%7B%22rank%22%3A2%2C%22num_filters%22%3A0%2C%22has_search%22%3Atrue%7D&parent=catalog&search_id=44407083)
- [Deep Dive into Global LB](https://cloud.google.com/blog/topics/developers-practitioners/google-cloud-global-external-https-load-balancer-deep-dive)

## architecture diagrams
![](https://github.com/aaron-dm-mcdonald/class6.5-notes/blob/main/060325/assets/console-to-tf-map.PNG)
![](https://github.com/aaron-dm-mcdonald/class6.5-notes/blob/main/060325/assets/GCP%2BGlobal%2BLB%2Bcomponents.png)
![](https://github.com/aaron-dm-mcdonald/class6.5-notes/blob/main/060325/assets/global-lb-v2.svg)

## Global LB test script
- [Old test script README](../041925/README.md)

- New LB:
 ```bash
 pip install locust
 
 locust -f <locustfile.py location> --headless -u 100 -r 10 --host http://<LB IP ADDRESS>
```


## naming convention

1) global resources named or prefixed with "app" or "lb"

2) regional resources named or prefixed with "region_a" or "region_b"

3) regional resources are segmented to files prefixed with "a" or "b" after the number of the file (9-mig.tf -> 9a-mig.tf)

## resources change list:
- variables.tf:
    - simple variables of type string are used
    - variable "region_a"       (the first region)
    - variable "subnet_a_cidr"  (the first subnet's CIDR range)
    - variable "region_b"       (the second region)
    - variable "subnet_b_cidr"  (the second subnet's CIDR range)
    - variable "app_name"       (application name)
    - in general these are used for the argument "name" too

- 3-subnets.tf: 
    - remove proxy only subnet
    - add additional subnet in different region

- 4-router.tf:
    - add additional router in different region
    - rename files to 4a-router.tf and 4b-router.tf

- 5-nat.tf:
    - add additional NAT gateway and static IP address for new region
    - rename files to 5a-nat.tf and 5b-nat.tf

- 7a-compute.tf: removed, VM demo no longer needed

- 7b-template.tf: 
    - add additional template
    - use different startup script for each template and add them in different regions
    - renamed to 7a-template.tf and 7b-template.tf

- 8-health-check.tf: 
    - change resource type from google_compute_region_health_check to google_compute_health_check
    - no other changes to parameters
    - scoped to global now so both MIGs can use it

- 9-mig.tf:
    - add additional MIG 
    - rename files to 9a-mig.tf and 9b-mig.tf

- 10-autoscale-policy.tf:
    - add additional autoscaling policy
    - rename files to 10a-autoscale-policy.tf and 10b-autoscale-policy.tf

- 11-lb-backend.tf:
    - change resource type from google_compute_region_health_check to google_compute_health_check
    - google_compute_backend_service gets an additional backend for the new region

- 12-lb-frontend.tf:
    - google_compute_address is changed to google_compute_global_address for global scope
    - google_compute_region_url_map is changed to google_compute_url_map for global scope
    - google_compute_region_target_http_proxy is changed to google_compute_target_http_proxy for global scope
    - google_compute_forwarding_rule is changed to google_compute_global_forwarding_rule for global scope
        - network and depends_on arguments are removed as they are no longer needed for a global resource

