
all:
	VAGRANT_DEFAULT_PROVIDER=vmware_fusion vmware_fusion vagrant up

rebuild:
	vagrant destroy --force
	VAGRANT_DEFAULT_PROVIDER=vmware_fusion vagrant up

deps:
	bundle
	bundle exec librarian-chef install