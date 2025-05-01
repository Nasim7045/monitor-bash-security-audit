#!/bin/bash

# Monitor System Resources Script for Proxy Server

# Function: Top 10 Applications by CPU and Memory Usage
top_10_apps() {
  echo -e "\n=== Top 10 Applications by CPU and Memory Usage ==="
  ps aux --sort=-%cpu,-%mem | head -n 11
}

# Function: Network Monitoring
network_monitoring() {
  echo -e "\n=== Network Monitoring ==="

  echo -n "Concurrent Connections: "
  netstat -an | grep ESTABLISHED | wc -l

  echo -n "Packet Drops: "
  netstat -s | grep 'packet receive errors' || echo "Not available"

  echo "Network I/O (MB):"
  cat /proc/net/dev | awk '
    /eth0|ens|enp/ {
      rx=$2/1048576; tx=$10/1048576;
      print "Interface: " $1 ", RX: " rx " MB, TX: " tx " MB"
    }
  '

  echo -e "\nDisk Usage by Mounted Partitions (Alert >80%):"
  df -h | awk '$5+0 > 80 {print $0 " <-- High Usage"}'

  echo -e "\nCurrent Load Average:"
  uptime

  echo -e "\nCPU Usage Breakdown:"
  if command -v mpstat >/dev/null 2>&1; then
    mpstat
  else
    echo "mpstat not found. Install it with: sudo apt install sysstat"
  fi
}

# Function: Disk Usage
disk_usage() {
  echo -e "\n=== Disk Usage ==="
  df -h
}

# Function: System Load
system_load() {
  echo -e "\n=== System Load ==="
  uptime
}

# Function: Memory Usage
memory_usage() {
  echo -e "\n=== Memory Usage ==="
  free -h
}

# Function: Process Monitoring
process_monitoring() {
  echo -e "\n=== Process Monitoring ==="
  echo -n "Number of Active Processes: "
  ps aux | wc -l

  echo -e "\nTop 5 Processes by CPU and Memory Usage:"
  ps aux --sort=-%cpu,-%mem | head -n 6
}

# Function: Service Monitoring
service_monitoring() {
  echo -e "\n=== Service Monitoring ==="
  for service in sshd nginx apache2 iptables safesquid; do
    if systemctl is-active --quiet "$service"; then
      echo "$service is running"
    else
      echo "$service is NOT running"
    fi
  done
}

# Function: Full Dashboard
dashboard() {
  echo -e "\n====================================="
  echo "     SYSTEM MONITORING DASHBOARD     "
  echo "====================================="

  top_10_apps
  network_monitoring
  disk_usage
  system_load
  memory_usage
  process_monitoring
  service_monitoring
}

# CLI with options
while getopts ":a:n:d:l:m:p:s:c" opt; do
  case $opt in
    a) top_10_apps ;;
    n) network_monitoring ;;
    d) disk_usage ;;
    l) system_load ;;
    m) memory_usage ;;
    p) process_monitoring ;;
    s) service_monitoring ;;
    c) dashboard ;;
    \?) echo "Invalid option: -$OPTARG" ;;
  esac
  exit
done

# Default: show dashboard if no options used
if [ $OPTIND -eq 1 ]; then
  dashboard
fi
