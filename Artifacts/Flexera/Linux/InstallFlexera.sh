	#Uninstall
	
	#cd /var/tmp/
	#rpm -e managesoft-13.0.1-1.x86_64
	
	
	
#!/bin/bash
rpm -qa | grep -i managesoft
if [ $? -eq 0 ]
then
echo "Installed"
else
echo "Installed"
cd /var/tmp
wget https://flexeratesting.blob.core.windows.net/testflexeracontainer/managesoft-13.0.1-1.x86_64.rpm
wget https://flexeratesting.blob.core.windows.net/testflexeracontainer/mgssetup.sh
chmod +x mgssetup.sh
sh mgssetup.sh
fi


