#!/usr/bin/env bash
    hostname ejbca;
    echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list;
    apt-get update ;
    apt-get -y install -t jessie-backports  openjdk-8-jre-headless ca-certificates-java;
    apt-get -y install openjdk-8-jdk ant ntp ant-optional unzip postgresql-9.5 postgresql-client-9.5 unzip;    
    mkdir -p  /etc/jboss; cd /opt/;
    unzip -q /opt/ejbca_ce_6_5.0.5.zip;
    unzip -q /opt/jboss-eap-7.0.0.zip;
    mv /opt/ejbca_ce_6_5.0.5 /opt/ejbca;
    mv /opt/jboss-eap-7.0 /opt/jboss;
    mv /opt/configurar-jboss /opt/scripts; 
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
    service jboss start;
#EJBCA
sudo -u postgres psql -U postgres <<OMG
 CREATE USER ejbca WITH PASSWORD 'ejbca';
 CREATE DATABASE ejbca WITH OWNER ejbca ENCODING 'UTF8' ;
OMG
