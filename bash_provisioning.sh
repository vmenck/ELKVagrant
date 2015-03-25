#!/usr/bin/env bash
#
#
echo "> Start provisioning..."

echo "> Apt-get update"
sudo apt-get update -y
echo ":>"

echo "> Install Java 7 (open-jdk)"
sudo apt-get install -y openjdk-7-jre
echo ":>"

sudo mkdir /opt/elk
cd /opt/elk

echo "> Downloading Elasticsearch 1.4.4"
sudo wget -nv https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.tar.gz
echo "> Downloading Logstash 1.4.2"
sudo wget -nv https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz
echo "> Downloading Kibana 4.0.0"
sudo wget -nv https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-linux-x86.tar.gz

echo "> Unzip elasticsearch-1.4.4.tar.gz"
sudo tar -zxf elasticsearch-1.4.4.tar.gz
echo "> Unzip logstash-1.4.2.tar.gz"
sudo tar -zxf logstash-1.4.2.tar.gz
echo "> Unzip kibana-4.0.0-linux-x86.tar.gz"
sudo tar -zxf kibana-4.0.0-linux-x86.tar.gz

sudo rm -rf elasticsearch-1.4.4.tar.gz logstash-1.4.2.tar.gz kibana-4.0.0-linux-x86.tar.gz

sudo chown -R vagrant:vagrant /opt/elk
sudo chmod -R 775 /opt/elk

#echo "> Installing Nginx" 
#sudo apt-get install -y nginx
#sudo service nginx start
#echo ":>"

echo "> Installing Redis-Server"
sudo apt-get install -y redis-server
echo ":>"

echo "Install Curl.."
sudo apt-get install -y curl
echo ":>"

echo "Elasticsearch configurations.."
cd /opt/elk/elasticsearch-1.4.4/config
cp elasticsearch.yml elasticsearch.yml.bkp
echo 'script.disable_dynamic: false' >> elasticsearch.yml

echo 'http.cors.allow-origin: "*"' >> elasticsearch.yml
echo 'http.cors.enabled: true' >> elasticsearch.yml
echo ":>"

echo "Elasticsearch plugins..."
cd /opt/elk/elasticsearch-1.4.4/bin
./plugin -install mobz/elasticsearch-head
./plugin -install royrusso/elasticsearch-HQ
echo ":>"

echo "Create directories local..."
mkdir /home/vagrant/elasticsearch
sudo chown -R vagrant:vagrant /home/vagrant/elasticsearch
sudo chmod -R 775 /home/vagrant/elasticsearch

mkdir /home/vagrant/kibana
sudo chown -R vagrant:vagrant /home/vagrant/kibana
sudo chmod -R 775 /home/vagrant/kibana

mkdir /home/vagrant/logstash
mkdir /home/vagrant/logstash/central
mkdir /home/vagrant/logstash/shipper
sudo chown -R vagrant:vagrant /home/vagrant/logstash
sudo chmod -R 775 /home/vagrant/logstash

sudo chown -R vagrant:vagrant /opt/elk

echo ":>"

echo "START Elasticsearch..."
cd /home/vagrant/elasticsearch
nohup bash /opt/elk/elasticsearch-1.4.4/bin/elasticsearch > elasticsearch.out&
echo ":>"

sleep 10

echo "Tail nohup - Elasticserach"
tail elasticsearch.out
echo ":>"

echo "START Kibana..."
cd /home/vagrant/kibana
nohup bash /opt/elk/kibana-4.0.0-linux-x86/bin/kibana > kibana.out&
echo ":>"

sleep 5

echo "Tail nohup - Kibana"
tail kibana.out
echo ":>"

echo "Logstash configurations.."
cp -rf /vagrant/logstash/log /home/vagrant/logstash
cp -rf /vagrant/logstash/central.conf /home/vagrant/logstash/central
cp -rf /vagrant/logstash/shipper.conf /home/vagrant/logstash/shipper
echo ":>"

sudo sh -xv /vagrant/print_message.sh

echo "Finish provisioning..."

##Logstash web
# http://thepracticalsysadmin.com/introduction-to-logstashelasticsearchkibana/
# http://michael.bouvy.net/blog/en/2013/11/19/collect-visualize-your-logs-logstash-elasticsearch-redis-kibana/
# https://www.digitalocean.com/community/tutorials/how-to-use-logstash-and-kibana-to-centralize-logs-on-centos-7
# http://blog.neu5ron.com/2014/12/setup-elasticsearch-logstash-and-kibana.html

##Nginx web
# https://www.ddreier.com/setting-up-elasticsearch-kibana-and-logstash/
