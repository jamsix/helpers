#!/bin/bash
packages=('requests-2.5.0' 'itsdangerous-0.24' 'MarkupSafe-0.23' 'Jinja2-2.8' 'Werkzeug-0.11.3' 'Flask-0.10.1' 'SQLAlchemy-1.0.11' 'Flask-SQLAlchemy-2.0')

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
apt-get remove te-va


for i in "${packages[@]}"
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

if [ -n "$1" ]; then
  wget -e use_proxy=yes -e http_proxy=$1 -e https_proxy=$1 http://mirrors.kernel.org/ubuntu/pool/universe/libo/libosip2/libosip2_4.0.0-3ubuntu2.debian.tar.gz
else
  wget http://mirrors.kernel.org/ubuntu/pool/universe/libo/libosip2/libosip2_4.0.0-3ubuntu2.debian.tar.gz
fi
dpkg -i libosip2-10_4.0.0-3ubuntu2_amd64.deb
rm libosip2-10_4.0.0-3ubuntu2_amd64.deb

if [ -n "$1" ]; then
  wget -e use_proxy=yes -e http_proxy=$1 -e https_proxy=$1 http://mirrors.kernel.org/ubuntu/pool/universe/n/ndisc6/rdnssd_1.0.1-1ubuntu1_i386.deb
else
  wget http://mirrors.kernel.org/ubuntu/pool/universe/n/ndisc6/rdnssd_1.0.1-1ubuntu1_i386.deb
fi
dpkg -i rdnssd_1.0.1-1ubuntu1_amd64.deb
rm rdnssd_1.0.1-1ubuntu1_amd64.deb


apt-get install te-va
apt-get install te-agent
apt-get install te-browserbot
