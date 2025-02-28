# Dockerfile for ECMRS Ansible install

FROM redhat/ubi9

# Install Ansible and dependencies
RUN yum update -y && \
yum install -y python3-pip  && \
pip3 install ansible

# Copy your ansible configuration into the image
COPY ansible /ansible

ENTRYPOINT ["tail", "-f", "/dev/null"]