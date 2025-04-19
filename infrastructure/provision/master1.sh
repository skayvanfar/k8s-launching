#!/bin/bash
set -e

# Wait for other masters to be ready
sleep 15

# Init kubeadm cluster
kubeadm init --control-plane-endpoint "192.168.56.100:6443" \
             --upload-certs --pod-network-cidr=10.244.0.0/16 > /vagrant/provision/kubeadm-init.out

# Set up kubectl for vagrant user
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Generate join commands
grep "kubeadm join" /vagrant/provision/kubeadm-init.out -A 2 > /vagrant/provision/join.sh
chmod +x /vagrant/provision/join.sh

# Install Flannel CNI
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
