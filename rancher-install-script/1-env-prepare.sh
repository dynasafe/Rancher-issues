#! /bin/bash
set -e

echo -e "\nPrepare CentOS. Set hostname"
echo "============================================================================="
#sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
#sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

echo -e "\nStep1. Install necessary package"
echo "============================================================================="
yum install -y curl yum-utils net-tools conntrack-tools wget

echo -e "\nStep2. Disable firewall and selinux"
echo "============================================================================="
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
systemctl stop firewalld && systemctl disable firewalld

echo -e "\nStep3. Install rke command"
echo "============================================================================="
curl -L https://github.com/rancher/rke/releases/download/v1.3.15/rke_linux-amd64 -o /usr/bin/rke
chmod +x /usr/bin/rke

echo -e "\nStep4. Install docker"
echo "============================================================================="
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin --allowerasing
sudo yum install -y docker-ce-20.10.9 docker-ce-cli-20.10.9 containerd.io docker-compose-plugin
systemctl start docker
systemctl enable docker

echo -e "\nStep5. Create user docker and setting password"
echo "============================================================================="
useradd -m docker -g docker
echo "Admin12345" | passwd --stdin docker

echo -e "\nStep6. Install Kubernetes tool"
echo "============================================================================="
wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz
tar zxvf openshift-client-linux.tar.gz
mv kubectl /usr/local/bin

wget https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64.tar.gz
tar zxvf helm-linux-amd64.tar.gz
mv helm-linux-amd64 /usr/local/bin/helm
