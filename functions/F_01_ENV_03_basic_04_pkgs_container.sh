echo "==============================="
echo "  Installing Container Management packages..."
echo "==============================="

dnf groupinstall -y "Container Management"

dnf install -y podman buildah skopeo runc conmon criu udica container-selinux
