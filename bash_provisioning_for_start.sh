#!/usr/bin/env bash
#
#
echo "> Start provisioning..."

echo "START Elasticsearch..."
cd /home/vagrant/elasticsearch
nohup bash /opt/elk/elasticsearch-1.4.4/bin/elasticsearch > elasticsearch.out&
echo ":>"

sleep 15

echo "Tail nohup - Elasticserach"
tail elasticsearch.out
echo ":>"

echo "START Kibana..."
cd /home/vagrant/kibana
nohup bash /opt/elk/kibana-4.0.0-linux-x86/bin/kibana > kibana.out&
echo ":>"

sleep 10

echo "Tail nohup - Kibana"
tail kibana.out
echo ":>"

#nohup /opt/elk/logstash-1.4.2/bin/logstash agent --verbose -f /home/vagrant/logstash/central/central.conf &
#nohup /opt/elk/logstash-1.4.2/bin/logstash agent --verbose -f /home/vagrant/logstash/shipper/shipper.conf &

echo "Finish provisioning..."