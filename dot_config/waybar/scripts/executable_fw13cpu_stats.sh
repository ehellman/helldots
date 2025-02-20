#!/bin/bash

sensors -j | jq --compact-output '
  .["cros_ec-isa-0000"] | {
    text: (.["local_f75303@4d"].temp1_input | floor | tostring),
      tooltip: ("Fan speed: " + (.fan1.fan1_input | floor | tostring) + " RPM\nCPU@4d temp: " + (.["cpu_f75303@4d"].temp2_input | floor | tostring + "°C")),
    class: "cputemp"
  }'
