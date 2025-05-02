Proxy Server Monitoring & Security Hardening on Linux
📁 System Overview
This project includes two key sets of automation scripts used on a Linux (x86_64) system running the SafeSquid Proxy ISO:

Set 1: Monitoring system resources for proxy server

Set 2: Scripts for performing security audits and hardening Linux servers

🖥️ Installation and Execution Setup
🔧 OS & Environment Setup
System: Linux (x86_64)

ISO Used: SafeSquid ISO (Bootable)

VM Platform: VMware Workstation (or similar)

How ISO was installed:

Downloaded SafeSquid ISO from the official site.

Created a new VM using Linux x64 as the base OS.

Attached the SafeSquid ISO as a boot disk.

Booted into the ISO and used terminal (CLI) environment for executing scripts.

🧩 Set 1: Monitoring System Resources for Proxy Server
📝 Script: monitor_bash.sh
This script provides a real-time dashboard and command-line flags to monitor:

🔼 Top 10 CPU & Memory consuming applications

🌐 Network usage (active connections, I/O, dropped packets)

💽 Disk usage (alerts if usage >80%)

📊 System load average

📈 Memory and process statistics

🛠️ Status of critical services like sshd, iptables, safesquid, etc.

▶️ How to Run:
bash
Copy
Edit
bash monitor_bash.sh           # Full dashboard mode

🛡️ Set 2: Scripts for Hardening Security Audits on Linux Servers
📝 Script: security_audit.sh
This script automates multiple security audit tasks, useful for system hardening:

🔍 Features:
👤 User & Group audits: List all users, UID 0 users, users without passwords

🔐 File & Directory checks: World-writable files, SUID/SGID files, .ssh permissions

🧩 Service audits: Running services, non-standard open ports

🔥 Firewall & Network security: ufw status, IP forwarding, iptables rules

🌐 IP configuration: Public/Private IPs, sensitive services on public IP

🚨 Security patching: Lists security updates and installs unattended-upgrades

📜 Log monitoring: Recent failed login attempts

🛠️ Hardening actions:

Disable SSH password login

Disable IPv6

Guide to setting GRUB password

Setup firewall with iptables-persistent

▶️ How to Run:
bash
Copy
Edit
sudo bash security_audit.sh
Logs are saved to: /var/log/security_audit.log (give it accurate place to store the files)

Should be run as root or using sudo for full audit and hardening.

✅ Requirements
Linux with Bash (default shell)

Tools required:

netstat

ufw

iptables

sysstat (for mpstat)

unattended-upgrades

iptables-persistent (for saving rules)

Install missing tools with:

bash
Copy
Edit
sudo apt install net-tools ufw iptables sysstat unattended-upgrades iptables-persistent
🏁 Final Notes
Make sure to give execute permissions to scripts:

bash
Copy
Edit
chmod +x monitor_bash.sh security_audit.sh
Always run the security audit script as root for accurate results and permission handling.
