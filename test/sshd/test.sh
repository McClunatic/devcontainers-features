#!/bin/sh

# Optional: Import test library
. ./dev-container-features-test-lib

check "sshd-init-exists" sh -c "ls /usr/local/share/ssh-init.sh" || exit 1
check "sshd-log-exists" sh -c "ls /tmp/sshd.log" || exit 1
# Debian contents checks
log_contents_grep="grep -e 'Starting OpenBSD Secure Shell server'"
# RHEL contents checks
log_contents_grep="${log_contents_grep} -e 'INFO:systemctl:notify started PID'"
log_contents_grep="${log_contents_grep} -e 'INFO:systemctl:notify start ./usr/sbin/sshd. .-D.'"
# Alpine contents checks
log_contents_grep="${log_contents_grep} -e 'Detaching to start ./usr/sbin/sshd.pam. ... \\[ ok \\]'"
log_contents_grep="${log_contents_grep} -e 'Starting sshd ... \\[ ok \\]'"
sleep 3  # Wait for sshd to write to /tmp/sshd.log
check "sshd-log-contents" sh -c "cat /tmp/sshd.log | ${log_contents_grep}" || exit 1
check "sshd-log-has-sshd" sh -c "cat /tmp/sshd.log | grep 'sshd'" || exit 1
check "sshd" sh -c "ps aux | grep -v grep | grep sshd" || exit 1

# Report result
reportResults
