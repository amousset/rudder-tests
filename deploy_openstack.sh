#!/bin/sh

rm -r tree configuration

cp -r ../ncf-openstack-technique/tree .
cp -r ../ncf-openstack-technique/configuration .

vagrant ssh ${1}_rudder -c "sudo cp -r /vagrant/tree/30_generic_methods/* /usr/share/ncf/tree/30_generic_methods/"
vagrant ssh ${1}_rudder -c "sudo cp -r /vagrant/tree/40_it_ops_knowledge/* /usr/share/ncf/tree/40_it_ops_knowledge/"

vagrant ssh ${1}_openstack -c "sudo mkdir -p /etc/rudder/openstack && sudo cp -r /vagrant/configuration/controller/* /etc/rudder/openstack/"

vagrant ssh ${1}_rudder -c "sudo rm -r /var/rudder/configuration-repository/ncf/50_techniques && sudo cp -r /vagrant/tree/50_techniques /var/rudder/configuration-repository/ncf/"
vagrant ssh ${1}_rudder -c "cd /var/rudder/configuration-repository/ncf/ && sudo chown -R ncf-api-venv:rudder . && sudo git add . && sudo git commit -m 'Add OpenStack techniques'"

vagrant ssh ${1}_rudder -c "sudo rudder agent update && sudo rudder agent run"