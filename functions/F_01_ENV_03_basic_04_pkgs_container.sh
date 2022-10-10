echo "==============================="
echo "  Installing Container Management packages..."
echo "==============================="

dnf groupinstall -y "Container Management"

local pkgs_list=""

pkgs_list="${pkgs_list} podman buildah skopeo"

pkgs_list="${pkgs_list} podman-compose"

pkgs_list="${pkgs_list} runc conmon criu udica container-selinux"

#-----------------------------------------------------------------------------------------
#Package Start to Install
#-----------------------------------------------------------------------------------------
dnf install -y ${pkgs_list}
