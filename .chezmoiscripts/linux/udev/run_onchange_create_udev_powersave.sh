#!/bin/bash
# If this does not work, try running:
# sudo udevadm monitor --subsystem-match=power_supply
# ... and then unplug/plug the power. look for change events ending in /ACAD,
# then use `udevadm info` to check what the ONLINE attribute is called. here's some
# example output:
# ❯ udevadm info --query=all --path=/devices/pci0000:00/0000:00:14.3/ACPI0003:00/power_supply/ACAD
# P: /devices/pci0000:00/0000:00:14.3/ACPI0003:00/power_supply/ACAD
# M: ACAD
# J: +power_supply:ACAD
# U: power_supply
# T: power_supply
# E: DEVPATH=/devices/pci0000:00/0000:00:14.3/ACPI0003:00/power_supply/ACAD
# E: SUBSYSTEM=power_supply
# E: DEVTYPE=power_supply
# E: POWER_SUPPLY_NAME=ACAD
# E: POWER_SUPPLY_TYPE=Mains
# E: POWER_SUPPLY_ONLINE=1 <--- this is the correct value
# sudo udevadm test /devices/pci0000:00/0000:00:14.3/ACPI0003:00/power_supply/ACAD
echo "[chezmoi] Creating powersave udev rule"
echo "Config: $XDG_CONFIG_HOME"
echo

supply_state_wrapper="ATTR" # seen: ATTR | ENV
power_supply_state_attr="online" # seen: online | POWER_SAVE_ONLINE

# create the udev rule file using $HOME
echo "SUBSYSTEM==\"power_supply\", ATTR{type}==\"Mains\", $supply_state_wrapper{$power_supply_state_attr}==\"0\", RUN+=\"$XDG_CONFIG_HOME/scripts/powersave true\"" | sudo tee /etc/udev/rules.d/99-powersave.rules > /dev/null
echo "SUBSYSTEM==\"power_supply\", ATTR{type}==\"Mains\", $supply_state_wrapper{$power_supply_state_attr}==\"1\", RUN+=\"$XDG_CONFIG_HOME/scripts/powersave false\"" | sudo tee -a /etc/udev/rules.d/99-powersave.rules > /dev/null

# set the correct permissions
sudo chmod 0644 /etc/udev/rules.d/99-powersave.rules

# reload udev rules
sudo udevadm control --reload

# reset sudo timeout
sudo -k

