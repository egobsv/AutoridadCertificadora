#!/usr/bin/env bash
    timedatectl set-timezone America/El_Salvador;
    hostnamectl set-hostname ejbca;
    cp /vagrant/*zip /opt/;
    cp -r /vagrant/scripts /opt/;
    cp /vagrant/dependencias/* /var/cache/apt/archives;
    apt-get update ;
    apt-get -y install openjdk-8-jre-headless ca-certificates-java;
    apt-get -y install openjdk-8-jdk ant ntp ant-optional unzip postgresql postgresql-client unzip;    
    mkdir -p  /etc/jboss; cd /opt/;
    unzip -q /opt/ejbca_ce_6_10_1_2.zip;
    unzip -q /opt/jboss-eap-7.0.0.zip;
    mv /opt/ejbca_ce_6_10_1_2 /opt/ejbca;
    mv /opt/jboss-eap-7.0 /opt/jboss;
    cp /opt/scripts/ejbca/* /opt/ejbca/conf/;
    cp /opt/scripts/jboss.conf /etc/jboss/;
    cp /opt/scripts/jboss.service /etc/systemd/system/;
    cp /opt/scripts/launch.sh /opt/jboss/bin/;
    chmod +x /opt/jboss/bin/launch.sh;

    groupadd -r jboss;
    useradd -r -g jboss -d /opt/jboss -s /sbin/nologin jboss;
    chown -R jboss:jboss /opt/jboss;
    chown -R jboss:jboss /opt/ejbca;
    sudo chmod -R 775 /opt/ejbca;
    systemctl start jboss.service;
    systemctl enable jboss.service;
#EJBCA
sudo -u postgres psql -U postgres <<OMG
 CREATE USER ejbca WITH PASSWORD 'ejbca';
 CREATE DATABASE ejbca WITH OWNER ejbca ENCODING 'UTF8' ;
OMG
