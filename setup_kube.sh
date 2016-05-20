cat << EOF >> /root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLX3wj0xlKtlCb/ZoMqbPEtzwWUC1leAlrHcwp/sScCanDAod4F52hDseE59YHSv3N8DY4HGdY9GEUnOpQzBiKYAsVykhrwr1wVF452IfX1WGG5JFtBL7+UfKMPArWPCota4NHSksG5xmhTAN5YDZYJmZlrTqpbcARPN9ls9BS1EooVyhFEu/T27CiNsNoO1KBd4CvetQVkTQOfMJrDBVYFScTnnMxfP36ktTmcYugDwlIAfiN5NLNTgD9CiMx8xtRb9AZd84J1rF0ScV3QFBvLhPf1WLtB8NAeLHcsZr3IRzsOsmZWqL+rmDx9hSYmRtgE5G0t5TTbv7Zz2oqPwtd jvance@redhat.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDrXuQi+FY2/vwu1+9T+SsMVu4uaVOt0RULx5SF0U26ZftIrhoD7W1CJAeZQVMrnyZ9EzVG6+cXNygdYAqifunLLeMDLm1rYgg11a3w0+DuVQUhCjJnmGOPfaAcjCsExhYbH1dRaf+nHqTRDvSHkXoaNA/mFjBeqNR4VlmEeyRv2DqrUVV1aOky/0whiaAKpbK6yzIgB1oJ4E3ki6iMI1XcqWumwWGRjSJVYQN4XDvA86Th9ZTyHAR0HE2LCJ8bCAfKAO51S4Rr9FYI1GvxEhU8ybxkw2lJKP4Y+rrowlKqNswF0645/40OazjnlLJQOmRsTjFrGCDTrJNYTdhWy6ZB jcope@localhost.localdomain
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6VfBKd6hqd5h7k5f+AtjJSV1hdW5u9/3uAolK3SD2/5GD9+rn+FMSdbtkeaKuuVJPi2HjnsVMO+r8WcuyN5ZSYHywiSoh4S7PamAxra1CLISsFHPYFlGrtdHC70wnoT7+/wAJk2D3CYkCNMWIxs5eR0cefDOytipBfDplhkJByyrcnXuhI8St3XJzpjlXu454diJOxfsk6axanWLOr/WZFmUi1U6V4gRE7XtKG9WFUm1bmNgkgd7lehKzi+isTjnI+b4tnD0yIzKFcsgIvLdGJTI6Lluj33CeBHIocwu0LbvowTyYSqhP6DzGhGuKfK9rMnJh/ll0Bnu1xf/ok0NSQ== Jpeerindex@doolittle-5.local
EOF

yum update -y;
yum install -y wget git htop tmux gcc;
cat << EOF > /root/.bash_profile 
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
 . ~/.bashrc
fi

# User specific environment and startup programs

ALLOW_PRIVILEGED=true
ALLOW_SECURITY_CONTEXT=true

GOPATH=/root/go
KPATH=$GOPATH/src/k8s.io/kubernetes
GO=/usr/local/go
PATH=$PATH:$HOME/bin:$GO/bin

export PATH
export GOPATH
export KPATH
EOF

cat << EOF > /root/.tmux.config
# set 256 color
set -g default-terminal "screen-256color"
EOF

source /root/.bash_profile
mkdir $KPATH
wget -P /tmp/ https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz
tar -xzf /tmp/go* -C /usr/local 
go version
git clone https://github.com/copejon/kubernetes.git $KPATH
