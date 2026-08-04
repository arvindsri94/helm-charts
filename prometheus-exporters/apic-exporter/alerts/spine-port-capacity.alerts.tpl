groups:
- name: apicexporter-spine-capacity.alerts
  rules:
  # Spine fabric port capacity planning.
  # Each pod consumes 6 spine ports; keep an operational buffer for the pod.
  # Evaluated PER POD so a single starved pod is not hidden by spare capacity in other pods.
  - alert: SpinePortCapacity
    expr: |
      sum by (region, pod_id) (network_apic_free_port_count{job="apic-exporter"}) < 7 > 2
    for: 5m
    labels:
      severity: warning
      support_group: network-data-aci-obs
      aci_obs_group: SpineCapacityGroup
    annotations:
      summary: "Spine Capacity Faults"
      description: "[{{`{{ $labels.region }}`}}][POD {{`{{ $labels.pod_id }}`}}] Available spine fabric port capacity is low; {{`{{ $value }}`}} free port(s) remaining"
