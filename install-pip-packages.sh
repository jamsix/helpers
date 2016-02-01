#!/bin/bash
pip_packages=('requests-2.5.0' 'itsdangerous-0.24' 'MarkupSafe-0.23' 'Jinja2-2.8' 'Werkzeug-0.11.3' 'Flask-0.10.1' 'SQLAlchemy-1.0.11' 'Flask-SQLAlchemy-2.0')
deb_packages=('libo/libosip2/libosip2-4_3.3.0-1ubuntu2_i386.deb' 'n/ndisc6/rdnssd_1.0.1-1ubuntu1_i386.deb' 'b/boost1.46/libboost-system1.46.1_1.46.1-7ubuntu3_i386.deb' 'b/boost1.46/libboost-filesystem1.46.1_1.46.1-7ubuntu3_i386.deb' 'b/boost1.46/libboost-thread1.46.1_1.46.1-7ubuntu3_i386.deb')

if [ -n "$1" ]; then
  export http_proxy=http://$1
  export https_proxy=https://$2
fi

PIP_OK=$(dpkg-query -W --showformat='${Status}\n' python-pip | grep "install ok installed")
if [ "" == "$PIP_OK" ]; then
  apt-get --force-yes --yes install python-pip python-dev build-essential
fi


apt-get clean all
apt-get update
apt-get -y remove te-va


for i in "${pip_packages[@]}"
do
  if [ ! -d ./"$i" ]; then
    if [ -n "$1" ]; then
      wget -e use_proxy=yes -e http_proxy=$1 -e https_proxy=$1 https://pypi.python.org/packages/source/${i:0:1}/${i%-*}/$i.tar.gz
    else
      wget https://pypi.python.org/packages/source/${i:0:1}/${i%-*}/$i.tar.gz
    fi
    tar -xvf $i.tar.gz
    rm $i.tar.gz
  fi
  pip install -e $i
done


for i in "${deb_packages[@]}"
do
  if [ -n "$1" ]; then
    wget -e use_proxy=yes -e http_proxy=$1 -e https_proxy=$1 http://mirrors.kernel.org/ubuntu/pool/universe/$i
  else
    wget http://mirrors.kernel.org/ubuntu/pool/universe/$i
  fi
  dpkg -i ${i##*/}
  rm ${i##*/}
done


apt-get -y install te-va
apt-get -y install te-agent
apt-get -y install te-browserbot
