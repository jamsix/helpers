#!/bin/bash
packages=('itsdangerous-0.24' 'MarkupSafe-0.23' 'Jinja2-2.8' 'Werkzeug-0.11.3' 'Flask-0.10.1' 'SQLAlchemy-1.0.11' 'Flask-SQLAlchemy-2.0')


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
    wget https://pypi.python.org/packages/source/${i:0:1}/${i%-*}/$i.tar.gz
    tar -xvf $i.tar.gz
    rm $i.tar.gz
  fi
  pip install -e $i
done


wget http://mirrors.kernel.org/ubuntu/pool/universe/libo/libosip2/libosip2-10_4.0.0-3ubuntu2_amd64.deb
dpkg -i libosip2-10_4.0.0-3ubuntu2_amd64.deb
rm libosip2-10_4.0.0-3ubuntu2_amd64.deb

wget http://mirrors.kernel.org/ubuntu/pool/universe/n/ndisc6/rdnssd_1.0.1-1ubuntu1_amd64.deb
dpkg -i rdnssd_1.0.1-1ubuntu1_amd64.deb
rm rdnssd_1.0.1-1ubuntu1_amd64.deb


apt-get install te-va
apt-get install te-agent
apt-get install te-browserbot
