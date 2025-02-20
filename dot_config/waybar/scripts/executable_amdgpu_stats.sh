#!/bin/bash

# Path to hwmon directory
# GPU_HWMON="/sys/class/hwmon/hwmon4"

# Function to read and format temperature
# read_temp() {
#     local input=$(cat "$HWMON/$1")
#     # Convert millidegrees to degrees
#     echo "scale=1; $input / 1000" | bc
# }

# Function to read and format fan speed
# read_fan() {
#     cat "$HWMON/$1"
# }

# Read all temperatures and fan speed
# LOCAL=$(read_temp "temp1_input")
# CPU=$(read_temp "temp2_input")
# RAM=$(read_temp "temp3_input")
# CPU4=$(read_temp "temp4_input")
# CPU_CORE3=$(read_temp "temp5_input")
# FAN=$(read_fan "fan1_input")
#
# # Output in JSON format for Waybar
# echo "{\"text\": \"🌡️${CPU}°C 💨${FAN}RPM\", \"tooltip\": \"CPU: ${CPU}°C\nCore 0: ${CPU_CORE0}°C\nCore 1: ${CPU_CORE1}°C\nCore 2: ${CPU_CORE2}°C\nCore 3: ${CPU_CORE3}°C\nFan: ${FAN} RPM\"}"
#
#
#!/bin/bash

# Run sensors and pipe the output to jq for processing
# sensors -j | jq --unbuffered --compact-output '
#   .["amdgpu-pci-c100"] | {
#     text: (.edge.temp1_input | floor | tostring + "°C"),
#     tooltip: "GPU: \(.vddgfx.in0_input)mV\nNB: \(.vddnb.in1_input)mV\nPower: \(.PPT.power1_input)W"
#   } | tojson'
sensors -j | jq --compact-output '
 .["amdgpu-pci-c100"] | {
   text: (.edge.temp1_input | floor | tostring),
   tooltip: "GPU Voltage: \(.vddgfx.in0_input | tostring + " mV")\nNorthbridge Voltage: \(.vddnb.in1_input | tostring + " mV")\nPackage power: \(.PPT.power1_input | . * 100 | floor | . / 100 | tostring + " W")\nPackage power (avg): \(.PPT.power1_average | . * 100 | floor | . / 100 | tostring + " W")",
   class: "gputemp"
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
