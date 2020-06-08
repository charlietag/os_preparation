

# -------- Solve dnf known issue --------
#  Problem: conflicting requests
#  - nothing provides module(perl:5.26) needed by module perl-DBI:1.641:8010020191113222731:16b3ab4d-0.x86_64
#dnf module enable perl:5.26/common -y
#   -> Ignoring unnecessary profile: common
dnf module enable perl:5.26 -y

