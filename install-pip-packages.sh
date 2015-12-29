#!/bin/bash
apt-get install python-pip python-dev build-essential

packages=('itsdangerous-0.24' 'MarkupSafe-0.23' 'Jinja2-2.8' 'Werkzeug-0.11.3' 'Flask-0.10.1' 'SQLAlchemy-1.0.11' 'Flask-SQLAlchemy-2.0')

for i in "${packages[@]}"
do
  wget https://pypi.python.org/packages/source/${i:0:1}/${i%-*}/$i.tar.gz
  tar -xvf $i.tar.gz
  rm $i.tar.gz
  pip install -e $i
done

apt-get update
apt-get install te-va
apt-get install te-agent
apt-get install te-browserbot
