
export VAGRANT_DEFAULT_PROVIDER=vmware_fusion

all:
	vmware_fusion vagrant up

provision:
	vagrant provision

rebuild:
	vagrant destroy --force
	VAGRANT_DEFAULT_PROVIDER=vmware_fusion vagrant up

deps:
	bundle
	bundle exec librarian-chef install