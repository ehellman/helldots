#!/bin/bash

# sensors -j | jq --compact-output '
#   .["cros_ec-isa-0000"] | {
#     text: (.["local_f75303@4d"].temp1_input | floor | tostring),
#       tooltip: ("Fan speed: " + (.fan1.fan1_input | floor | tostring) + " RPM\nCPU@4d temp: " + (.["cpu_f75303@4d"].temp2_input | floor | tostring + "°C")),
#     class: "cputemp"
#   }'

sensors -j | jq --compact-output '
  .["cros_ec-isa-0000"] | {
    text: (.["cpu@4c"].temp4_input | floor | tostring),
      tooltip: ("Fan speed: " + (.fan1.fan1_input | floor | tostring) + " RPM"),
    class: "cputemp"
  }'
# sensors -j | jq --compact-output '
#   .["amdgpu-pci-c100"] | {
#     vddgfx: (.vddgfx.in0_input | tostring + " mV"),
#     vddnb: (.vddnb.in1_input | tostring + " mV"),
#     temp: (.edge.temp1_input | floor | tostring),
#     ppt: (.PPT.power1_input | . * 100 | floor | . / 100 | tostring + " W"),
#     ppt_avg: (.PPT.power1_average | . * 100 | floor | . / 100 | tostring + " W")
#   }
# '
