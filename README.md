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
 pip install locust
 
 locust -f <locustfile.py location> --headless -u 100 -r 10 --host http://<LB IP ADDRESS>



## naming convention

1) global resources named or prefixed with "app" or "lb"

2) regional resources named or prefixed with "region_a" or "region_b"

## resources migrated:

- 3-subnets.tf:

- 4-router.tf:

- 5-nat.tf:

- 7a-compute.tf: removed, VM demo no longer needed

- 7b-template.tf: renamed to 7-template.tf

- 8-health-check.tf: google_compute_region_health_check -> google_compute_health_check

- 9-mig.tf:

- 10-autoscale-policy.tf:

- 11-lb-backend.tf:

- 12-lb-frontend.tf:
