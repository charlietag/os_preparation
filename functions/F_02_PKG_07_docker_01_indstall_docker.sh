# ----------------------------------
# Content
# ----------------------------------
# All content is stored as below by default
# /var/lib/docker/


# ----------------------------------
# prerequisite packages
# ----------------------------------
yum install -y
                yum-utils \
                device-mapper-persistent-data \
                lvm2


# ----------------------------------
# Install docker-ce
# ----------------------------------
yum install -y docker-ce


# ----------------------------------
# By default, disable docker onboot
# ----------------------------------
systemctl disable docker
