#!/bin/bash
# $> ./temp_cpu_gpu.sh
# Показывает температуру CPU и GPU (адаптированный вариант)

temp_cpu() {
  local gpu_raw=$(cat $(grep -l k10temp /sys/class/hwmon/hwmon*/name \
                 | head -1 | xargs dirname)/temp1_input)
  awk "BEGIN {printf \"%.1f\", $gpu_raw / 1000}"
}

temp_amdgpu_cat() {
  local cpu_raw=$(find /sys/class/drm/card*/device/hwmon -name "temp*_input" -exec cat {} \; | head -1)
  awk "BEGIN {printf \"%.1f\", $cpu_raw / 1000}"
}

temp_amdgpu_sensors() {
  # дополнительный вариант
  sensors -j 2>/dev/null \
  | jq -r '.["amdgpu-pci-0500"].edge.temp1_input' \
  | awk '{printf "%.0f", $1}'
}

temp_nvidia_gpu() {
  nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader
}

echo -e "CPU: \033[36m$(temp_cpu)\033[0m°C \
| AMD: \033[36m$(temp_amdgpu_cat)\033[0m°C \
| NVIDIA: \033[36m$(temp_nvidia_gpu)\033[0m°C"

