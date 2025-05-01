#!/bin/bash

# Security Audit and Hardening Script for Linux Servers
# Run as root: sudo ./security_audit.sh

LOGFILE="/var/log/security_audit.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "========== SECURITY AUDIT STARTED: $(date) =========="

# Function: User and Group Audits
user_group_audit() {
    echo -e "\n=== User and Group Audits ==="

    echo "All users:"
    cut -d: -f1 /etc/passwd

    echo -e "\nAll groups:"
    cut -d: -f1 /etc/group

    echo -e "\nUsers with UID 0 (root privileges):"
    awk -F: '($3 == "0") {print}' /etc/passwd

    echo -e "\nUsers without passwords:"
    awk -F: '($2 == "") {print $1}' /etc/shadow
}

# Function: File and Directory Permissions
file_permissions_audit() {
    echo -e "\n=== File and Directory Permissions Audit ==="

    echo "World-writable files (restricted to home, etc, var, opt):"
    find /home /etc /var /opt -type f -perm -o+w -exec ls -l {} \;

    echo -e "\nSSH directory permissions:"
    find /home -type d -name ".ssh" -exec ls -ld {} \;

    echo -e "\nFiles with SUID/SGID bits set:"
    find /home /etc /var /opt -perm /6000 -exec ls -ld {} \;
}

# Function: Service Audits
service_audit() {
    echo -e "\n=== Service Audits ==="

    echo "Running services:"
    systemctl list-units --type=service --state=running

    echo -e "\nOpen ports and services:"
    netstat -tuln
}

# Function: Firewall and Network Security
firewall_network_security() {
    echo -e "\n=== Firewall and Network Security ==="

    echo "Firewall status (ufw):"
    ufw status

    echo -e "\nOpen ports (netstat):"
    netstat -tulnp | grep LISTEN

    echo -e "\nIP Forwarding status:"
    sysctl net.ipv4.ip_forward
}

# Function: IP and Network Configuration Checks
ip_network_config_checks() {
    echo -e "\n=== IP and Network Configuration Checks ==="

    echo "Interface IPs:"
    ip addr | grep "inet"

    echo -e "\nSensitive services on public IPs (ports 22/443):"
    netstat -tulnp | grep -E ':22|:443'
}

# Function: Security Updates and Patching
security_updates_patching() {
    echo -e "\n=== Security Updates and Patching ==="

    echo "Available security updates:"
    apt update
    apt list --upgradable | grep security

    echo -e "\nInstalling unattended-upgrades if not present:"
    apt install -y unattended-upgrades
    dpkg-reconfigure -plow unattended-upgrades
}

# Function: Log Monitoring
log_monitoring() {
    echo -e "\n=== Log Monitoring ==="

    echo "Recent failed login attempts:"
    grep -i "failed" /var/log/auth.log | tail -n 10
}

# Function: Server Hardening Steps
server_hardening() {
    echo -e "\n=== Server Hardening ==="

    echo "Disabling SSH password authentication (key-based login only):"
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd

    echo -e "\nDisabling IPv6:"
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sysctl -w net.ipv6.conf.default.disable_ipv6=1

    echo -e "\nSecuring GRUB (run manually):"
    echo "Run 'grub-mkpasswd-pbkdf2' manually to generate encrypted password for GRUB."
    echo "Then edit /etc/grub.d/40_custom accordingly."

    echo -e "\nApplying basic iptables firewall rules:"
    iptables -P INPUT DROP
    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT

    echo "Saving iptables rules:"
    apt install -y iptables-persistent
    iptables-save > /etc/iptables/rules.v4
}

# Function: Custom Security Checks
custom_security_checks() {
    echo -e "\n=== Custom Security Checks ==="
    echo "No custom checks defined."
}

# Function: Reporting and Alerting
reporting_alerting() {
    echo -e "\n=== Reporting and Alerting ==="
    echo "Security audit report saved to $LOGFILE"
}

# Main Execution
main() {
    user_group_audit
    file_permissions_audit
    service_audit
    firewall_network_security
    ip_network_config_checks
    security_updates_patching
    log_monitoring
    server_hardening
    custom_security_checks
    reporting_alerting

    echo -e "\n========== AUDIT COMPLETED: $(date) ==========\n"
}

main
