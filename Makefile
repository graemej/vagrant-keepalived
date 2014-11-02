
all:
	vmware_fusion vagrant up

provision:
	vagrant provision

rebuild:
	vagrant destroy --force
	VAGRANT_DEFAULT_PROVIDER=vmware_fusion vagrant up

%.reload:
	VAGRANT_DEFAULT_PROVIDER=vmware_fusion vagrant reload --provision $<

%.ssh:
	VAGRANT_DEFAULT_PROVIDER=vmware_fusion vagrant ssh $<

deps:
	bundle
	bundle exec librarian-chef install