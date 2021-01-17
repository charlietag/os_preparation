# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# Setup config and command
task_copy_using_render_sed

# ------------------------------------
# NO NEED TO MASK : service template file move to folder, /usr/local/bin/puma-mgr_template
#
# Disable deprecated puma.service (Puma 5 - No daemon option)
#systemctl mask puma
# ------------------------------------


# Make puma-systemd-mgr executable
chmod 755 /usr/local/bin/puma-systemd-mgr
