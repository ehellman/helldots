#!/bin/bash

 sensors -j | jq --compact-output '
  .["cros_ec-isa-0000"] | 
  if .fan1.fan1_input < 1 then
    empty 
  else {
    text: (.fan1.fan1_input | floor),
  }
  end'
