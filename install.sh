#!/bin/bash

# ============================== Define variables ==============================
OH2UPDATE=''
OH3UNTEST=''
OH3UPDATE=''
OHNONE=''
OHINSTALL=''
QBUSNEW=''
INSTMONO=''
ISAMBA=''
USERVAR=''
PASSVAR=''
IPVAR=''
SNVAR=''
JAVA=''

DISPLTEXT=''
DISPLCOLOR=''

# ============================== Define colors ==============================
DISPLTEXT=''
DISPLCOLOR=''

BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# ============================== Define functions ==============================
spin(){
  spinner="/|\\-/|\\-"
  while :
  do
    for i in `seq 0 7`
    do
      echo -n "${spinner:$i:1}"
      echo -en "\010"
      sleep 0.1
    done
  done
}

echoInColor(){
	echo -e "$DISPLCOLOR$DISPLTEXT"
}

echoInColorP(){
	echo -en "$DISPLCOLOR$DISPLTEXT"
}

installMono(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo apt-get --assume-yes install mono-runtime mono-vbnc mono-complete > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

installJava11(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo apt-get --assume-yes install openjdk-11-jdk-headless > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

downloadQbus(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	git clone https://github.com/QbusKoen/QbusOH3 /tmp/qbus/ > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

copyJar(){
	sudo rm /usr/share/openhab/addons/org.openhab.binding.qbus.* > /dev/null 2>&1
	sudo cp /tmp/qbus/JAR/org.openhab.binding.qbus-3.2.0-SNAPSHOT.jar /usr/share/openhab/addons/ > /dev/null 2>&1
}

createChangeSettings(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo rm /tmp/qbus/setctd.sh > /dev/null 2>&1

	echo "#!/bin/bash" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo \"   ____  _                 ___                           _    _          ____  \"" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo \"  / __ \| |               |__ \                         | |  | |   /\   |  _ \ \"" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo \" | |  | | |__  _   _ ___     ) |   ___  _ __   ___ _ __ | |__| |  /  \  | |_) |\"" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo \" | |  | | '_ \| | | / __|   / /   / _ \| '_ \ / _ \ '_ \|  __  | / /\ \ |  _ < \"" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo \" | |__| | |_) | |_| \__ \  / /_  | (_) | |_) |  __/ | | | |  | |/ ____ \| |_) |\"" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo \"  \___\_\_.__/ \__,_|___/ |____|  \___/| .__/ \___|_| |_|_|  |_/_/    \_\____/ \"" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo \"                                       | |                                     \"" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo \"                                       |_|                                     \"" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo ''" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "read -p 'Enter username of your controller: ' USERVAR" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo -n 'Enter the password of your controller: '" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "unset password;" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "while IFS= read -r -s -n1 pass; do" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "  if [[ -z \$pass ]]; then" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "     echo" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "     break" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "  else" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "     echo -n '*'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "     PASSVAR+=\$pass" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "  fi" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "done" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "if [[ \$PASSVAR == '' ]]; then" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "        PASSVAR='none'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "fi" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "read -p 'Enter the ip address of your controller: ' IPVAR" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "read -p 'Enter the serial number of your controller: ' SNVAR" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "sudo rm /lib/systemd/system/qbusclient.service" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "# Create Client service" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '[Unit]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'Description=Client for Qbus communication' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'After=multi-user.target qbusserver.service' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '[Service]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'Type=simple' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'ExecStart= mono /usr/bin/qbus/qbusclient/QbusClient.exe '\$IPVAR' '\$USERVAR' '\$PASSVAR' '\$SNVAR' 100' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'Restart=always' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'StandardOutput=append:/var/log/qbus/qbusclient.log' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'StandardError=append:/var/log/qbus/qbusclient_error.log' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '[Install]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'WantedBy=multi-user.target' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1

	echo "sudo systemctl daemon-reload" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "sudo systemctl restart qbusclient.service" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1

	sudo cp /tmp/qbus/setctd.sh ~/setctd.sh > /dev/null 2>&1
	sudo chmod +x ~/setctd.sh > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

installQbus(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`

	# Remove old files
	sudo rm -R /usr/bin/qbus > /dev/null 2>&1

	# Create software directory
	sudo mkdir /usr/bin/qbus > /dev/null 2>&1
	sudo mkdir /usr/bin/qbus/qbusclient/ > /dev/null 2>&1
	sudo mkdir /usr/bin/qbus/qbusserver/ > /dev/null 2>&1

	# Copy files to correct location
	sudo cp -R /tmp/qbus/QbusClient/. /usr/bin/qbus/qbusclient/ > /dev/null 2>&1
	sudo cp -R /tmp/qbus/QbusServer/. /usr/bin/qbus/qbusserver/ > /dev/null 2>&1

	# Modify config file
	sudo sed -i "s|<value>.\+</value>|<value>/usr/bin/qbus/qbusclient/</value>|g" /usr/bin/qbus/qbusclient/QbusClient.exe.config > /dev/null 2>&1
	
	# Create cleanup.sh
	sudo sudo rm /usr/bin/qbus/qbusclient/cleanup.sh  > /dev/null 2>&1
	echo '#!/bin/bash' | sudo tee -a /usr/bin/qbus/qbusclient/cleanup.sh > /dev/null 2>&1
	echo '' | sudo tee -a /usr/bin/qbus/qbusclient/cleanup.sh > /dev/null 2>&1
	echo "rm -R /usr/bin/qbus/qbusclient/'HomeCenter\Temp\'" | sudo tee -a /usr/bin/qbus/qbusclient/cleanup.sh > /dev/null 2>&1
	echo 'rm /usr/bin/qbus/qbusclient/*.zip' | sudo tee -a /usr/bin/qbus/qbusclient/cleanup.sh > /dev/null 2>&1
	sudo chmod +x /usr/bin/qbus/qbusclient/cleanup.sh > /dev/null 2>&1
	sudo sed -i "s|loc|/usr/bin/qbus/qbusclient|g" /usr/bin/qbus/qbusclient/QbusClient.exe.config > /dev/null 2>&1

	# Create directory for logging
	sudo mkdir /var/log/qbus/ > /dev/null 2>&1

	# Deleting old service files
	sudo rm /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	sudo rm /lib/systemd/system/qbusserver.service > /dev/null 2>&1


	# Create Client service
	echo '[Unit]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'Description=Client for Qbus communication' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'After=multi-user.target qbusserver.service' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo '[Service]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'Type=simple' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'ExecStart= mono /usr/bin/qbus/qbusclient/QbusClient.exe '$IPVAR' '$USERVAR' '$PASSVAR' '$SNVAR' 100' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'Restart=always' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'StandardOutput=append:/var/log/qbus/qbusclient.log' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'StandardError=append:/var/log/qbus/qbusclient_error.log' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo '[Install]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'WantedBy=multi-user.target' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1

	# Create Server service
	echo '[Unit]' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'Description=Server for Qbus communication' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'After=multi-user.target' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo '' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo '[Service]' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'Type=simple' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'ExecStart= mono /usr/bin/qbus/qbusserver/QServer.exe' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'Restart=always' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'StandardOutput=append:/var/log/qbus/qbusserver.log' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'StandardError=append:/var/log/qbus/qbusserver.log' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo '' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo '[Install]' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'WantedBy=multi-user.target' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1

	kill -9 $SPIN_PID
}

startQbus(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo systemctl daemon-reload > /dev/null 2>&1
	sudo systemctl enable qbusserver.service > /dev/null 2>&1
	sudo systemctl start qbusserver.service > /dev/null 2>&1
	sudo systemctl enable qbusclient.service > /dev/null 2>&1
	sudo systemctl start qbusclient.service > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

checkOH(){
	OH2=$(ls /usr/share/openhab2 2>/dev/null)
	OH3=$(ls /usr/share/openhab 2>/dev/null)

	if [[ $OH2 != "" ]]; then
	  # OH2 found
	  OH="OH2"
	elif [[ $OH3 != "" ]]; then
	  # OH3 found, checking release
	  OH3V=$(cat /etc/apt/sources.list.d/openhab.list)
	  if [[ $OH3V =~ "unstable" ]]; then
			OH="OH3Unstable"
	  elif [[ $OH3V =~ "testing" ]]; then
			OH="OH3Testing"
	  elif [[ $OH3V =~ "stable" ]]; then
			OH="OH3Stable"
	  fi
	else
	  # OH not installed
	  OH = "None"
	fi
}

backupOpenhabFiles(){
	if [[$OH="OH2"]]; then
			sudo cp -R /etc/openhab2 /tmp/ > /dev/null 2>&1
	else
			sudo cp -R /etc/openhab /tmp/ > /dev/null 2>&1
	fi
}

restoreOpenhabFiles(){
	if [[$OH="OH2"]]; then
			sudo rm /etc/openhab2
			sudo mv /tmp/openhab2 /tmp/openhab
			sudo cp -R /tmp/openhab2 /etc/
	else
			sudo rm /etc/openhab
			sudo cp -R /tmp/openhab /etc/
	fi
}

installSamba(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15
	
	sudo apt-get --assume-yes install samba samba-common-bin` > /dev/null 2>&1
	echo '# Windows Internet Name Serving Support Section:' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo '# WINS Support - Tells the NMBD component of Samba to enable its WINS Server' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo 'wins support = yes' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo '' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo '[openHAB]' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo ' comment=openHAB Share' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo ' path=/etc/openhab' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo ' browseable=Yes' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo ' writeable=Yes' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo ' only guest=no' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo ' create mask=0777' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo ' directory mask=0777' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	echo ' public=no' | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

installOpenhab3(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo apt-get install apt-transport-https > /dev/null 2>&1
	wget -qO - 'https://bintray.com/user/downloadSubjectPublicKey?username=openhab' | sudo apt-key add - > /dev/null 2>&1
	sudo rm /etc/apt/sources.list.d/openhab.list > /dev/null 2>&1
	echo 'deb https://openhab.jfrog.io/artifactory/openhab-linuxpkg stable main' | sudo tee /etc/apt/sources.list.d/openhab.list > /dev/null 2>&1
	sudo apt-get --assume-yes update && sudo apt-get --assume-yes install openhab > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

removeOpenHAB3(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo apt-get --assume-yes purge openhab > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

removeOpenHAB2(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo apt-get --assume-yes purge openhab2 > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

updateRpi(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo apt-get  --assume-yes update > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}


# ============================== Start installation ==============================
DISPLCOLOR=${ORANGE}
DISPLTEXT='   ____  _                 ___                           _    _          ____  '
echoInColor
DISPLTEXT='  / __ \| |               |__ \                         | |  | |   /\   |  _ \ '
echoInColor
DISPLTEXT=" | |  | | |__  _   _ ___     ) |   ___  _ __   ___ _ __ | |__| |  /  \  | |_) |"
echoInColor
DISPLTEXT=" | |  | | '_ \| | | / __|   / /   / _ \| '_ \ / _ \ '_ \|  __  | / /\ \ |  _ < "
echoInColor
DISPLTEXT=" | |__| | |_) | |_| \__ \  / /_  | (_) | |_) |  __/ | | | |  | |/ ____ \| |_) |"
echoInColor
DISPLTEXT="  \___\_\_.__/ \__,_|___/ |____|  \___/| .__/ \___|_| |_|_|  |_/_/    \_\____/ "
echoInColor
DISPLTEXT="                                       | |                                     "
echoInColor
DISPLTEXT="                                       |_|                                     "
echoInColor
DISPLTEXT=""
echoInColor
DISPLCOLOR=${NC}
DISPLTEXT="Release date 23/11/2021 by ks@qbus.be"
echoInColor
echo ''
DISPLTEXT="Welcome to the Qbus2openHAB installer."
echoInColor
DISPLCOLOR=${RED}
DISPLTEXT="At the moment the openHAB binding for Qbus is being checked by openHAB developers, so you won't find the binding in the repository yet."
echoInColor
DISPLTEXT="Therefore we will install the current JAR file so you can use the binding anyway, you just don't have to install it from the Bindings list. It will be pre-installed."
echoInColor
DISPLTEXT="Since we are developing for the latest release of openHAB, the testing (3.2.0M4) version, we will install this version. If you already have an openHAB setup, then "\
"we will remove the stable version and change it with the testing version."
echoInColor
echo ""

# ---------------- Check for Mono -----------------------
DISPLCOLOR=${YELLOW}
DISPLTEXT="-- Checking Mono..."
echoInColor

MONO=$(which mono 2>/dev/null)
if [[ $MONO != "" ]]; then
	DISPLCOLOR=${GREEN}
	DISPLTEXT='     Mono is already installed.'
	echoInColor
else
	read -p "$(echo -e $YELLOW"     We did not detect Mono on your system. For the moment the Qbus client/server is based on .net. Therefore Mono is neccesary to run the client/server. Do you agree to install Mono (y/n)? "$NC)" INSTMONO
	if [[ $INSTMONO == "n" ]]; then
		DISPLTEXT='     Sorry, if you do not install Mono, you can not use the Qbus Client/Server application.'
		DISPLCOLOR=${RED}
		echoInColor
		exit 1
	fi
fi
echo ''

# ---------------- Check for Qbus Client/Server -----------------------
DISPLCOLOR=${YELLOW}
DISPLTEXT='-- Checking Qbus client/server...'
echoInColor

QBUS=$(ls /lib/systemd/system/qbusclient.service 2>/dev/null)
if [[ $QBUS != "" ]]; then
	QBUS2=$(ls /usr/bin/qbus/ 2>/dev/null)
	if [[ $QBUS2 != "" ]]; then
		DISPLTEXT='     -You already have Qbus client and server installed. The files will be updated.'
		DISPLCOLOR=${GREEN}
		echoInColor
	else
		DISPLTEXT='     -We have detected the previous version of the Qbus client/server. This version will be removed and the newest will be installed. The directory ~/QbusOpenHab will no longer be used. '\
		'The Qbus Client/Server application will be installed in /usr/bin/qbus/. We will try to remove ~/QbusOpenHab if this fails, please remove the directory.'
		DISPLCOLOR=${ORANGE}
		echoInColor
	fi
else
	DISPLTEXT='     -Qbus client/server is not found on your sytem. We will install this.'
	DISPLCOLOR=${YELLOW}
	echoInColor
fi
echo ''

# ---------------- Ask Qbus credentials  -----------------------
DISPLTEXT='      To communicate with your controller, it is necessary that the SDK (DLL) option is enabled. (see https://openhab-wiki.qbus.be/nl/inleiding).'
DISPLCOLOR=${RED}
echoInColor

DISPLTEXT='      Make sure the option is enabled before continuing'
DISPLCOLOR=${RED}
echoInColor

echo ''

DISPLTEXT='-- Configure client to communicate with CTD controller...'
DISPLCOLOR=${YELLOW}
echoInColor

read -p "$(echo -e $YELLOW"     -Enter username of your controller: "$NC)" USERVAR


DISPLTEXT='     -Enter the password of your controller: '
DISPLCOLOR=${YELLOW}
echoInColorP

echo -e -n "$NC"
unset pass;
while IFS= read -r -s -n1 pass; do
  if [[ -z $pass ]]; then
     echo
     break
  else
     echo -n '*'
     PASSVAR+=$pass
  fi
done

if [[ $PASSVAR == '' ]]; then
        PASSVAR='none'
fi

read -p "$(echo -e $YELLOW"     -Enter the ip address of your controller: "$NC)" IPVAR
read -p "$(echo -e $YELLOW"     -Enter the serial number of your controller: "$NC)" SNVAR
echo ''

# ---------------- Check for Samba -----------------------
DISPLTEXT='-- Checking SMB...'
DISPLCOLOR=${YELLOW}
echoInColor

SAMBA=$(ls /etc/samba/ 2>/dev/null)
if [[ $SAMBA != "" ]]; then
	DISPLTEXT='     -Samba Share is installed.'
	DISPLCOLOR=${GREEN}
	echoInColor
	
	SMB=$(cat /etc/samba/smb.conf)

    if [[ $SMB =~ "path=/etc/openhab2" ]]; then
      DISPLTEXT='     -Samba Share is configured for openhab2, changing to openhab...'
	  DISPLCOLOR=${GREEN}
	  echoInColor
      sed -i "s|path=/etc/openhab2|path=/etc/openhab|g" /etc/samba/smb.conf
    fi

    SMBUSER=$(sudo pdbedit -L 2>/dev/null)
	
    if [[ $SMBUSER =~ "openhab" ]]; then
      DISPLTEXT='     -openHAB user is already configured for Samba Share'
	  DISPLCOLOR=${GREEN}
	  echoInColor
    else
      DISPLTEXT='     -openHAB user is not configured for Samba Share.'
	  DISPLCOLOR=${RED}
	  echoInColor
	  
      DISPLTEXT='     -Enter a password for the Samba Share for the user openhab & repeat it: '
	  DISPLCOLOR=${YELLOW}
	  echoInColor
	  
	  echo -e -n "$NC"
      sudo smbpasswd -a openhab
    fi
else
	read -p "$(echo -e $YELLOW"     -We did not detect Samba Share on your system. You don not really need SMB, but it makes it easier to configure certain openHAB things. Do you agree to install Samba share (y/n)? " $NC)" INSTSAMBA
        
	if [[ $INSTSAMBA == "n" ]]; then
		DISPLTEXT='     -You choose not to install Samba Share. This means you have to configure certain openHAB things on this device.'
		DISPLCOLOR=${RED}
		echoInColor
	fi
fi
echo ''

# ---------------- Check Java JDK 11 -----------------------
DISPLTEXT='-- Checking JAVA JDK 11...'
DISPLCOLOR=${YELLOW}
echoInColor
 
JAVA=$(java --version)

if [[ $JAVA =~ "11." ]]; then
	DISPLTEXT='     -JAVA JDK 11 is installed.'
	DISPLCOLOR=${GREEN}
	echoInColor
else
    read -p "$(echo -e $YELLOW"     -JAVA JDK 11 is not installed on your system. This is required for the correct functionality of openHAB. Do you agree to install JAVA JDK 11 (y/n)? " $NC)" INSTJAVA
	if [[ $INSTJAVA == "n" ]]; then
		DISPLTEXT='     -You choose to not install JAVA, You may have problems running openHAB.'
		DISPLCOLOR=${RED}
		echoInColor
	fi
fi

echo ""

# ---------------- Check openHAB -----------------------
DISPLTEXT='-- Checking openHAB...'
DISPLCOLOR=${YELLOW}
echoInColor

checkOH

case $OH in
	OH2)
		read -p "$(echo -e $YELLOW"     -We have detected openHAB2 running on your device. The Qbus Binding is developped for the newest version of openHAB (3). For this moment the binding does not work with te stable release of openHAB (3.0.1), the testing realse (3.1.0M2) should be used. Do you agree that we remove openHAB2 and install the testing relaese of openHAB? (y/n)? " $NC)" OH2UPDATE
		;;
	OH3Unstable)
		read -p "$(echo -e $YELLOW"     -We have detected openHAB running the unstable (3.1.0-SNAPSHOT) version. Do you want to keep this version? (y) or do you want to install the testing realse (3.1.0M2) which is more stable? (y/n) " $NC)" OH3UNTEST
		;;
	OH3Testing)
		DISPLTEXT='     -We have detected openHAB running the testing (3.1.0Mx) version. We will upgrade to be shure to have the latest Milestone release.'
		DISPLCOLOR=${GREEN}
		echoInColor
		;;
	OH3Stable)
		read -p "$(echo -e $YELLOW"     -We have detected openHAB running the stable version (3.0.1). For this moment the binding does not work with te stable release of openHAB (3.0.1), the testing realse (3.1.0M2) should be used. Do you agree that we remove the main release and install the testing relaese of openHAB? (y/n) " $NC)" OH3UPDATE
		;;
	None)
		DISPLTEXT='     -We did not detected openHAB running on your system. For this moment the binding does not work with te stable release of openHAB (3.0.1), the testing realse (3.1.0M2) will be installed.'
		DISPLCOLOR=${GREEN}
		echoInColor
		;;
esac

# ---------------- Install -----------------------
echo ''

DISPLTEXT='****************************************************************************************************************'
DISPLCOLOR=${ORANGE}
echoInColor

DISPLTEXT='* Everything is set, we will start the installation. As they say: Now it is time to relax and drink a coffee... *'
DISPLCOLOR=${ORANGE}
echoInColor

DISPLTEXT='****************************************************************************************************************'
DISPLCOLOR=${ORANGE}
echoInColor

echo ''

#DISPLTEXT='* Updating your system.'
#DISPLCOLOR=${YELLOW}
#echoInColor

#updateRpi

if [[ $INSTMONO == "y" ]]; then
	DISPLTEXT='* Installing Mono...'
	echoInColor
	installMono
	echo ''
fi

DISPLTEXT='* Downloading Qbus client and server...'
echoInColor
downloadQbus
echo ''

DISPLTEXT='* Install Qbus client and server...'
echoInColor
installQbus
echo ''

if [[ $INSTJAVA == "y" ]]; then
	DISPLTEXT='* Installing Java JDK 11...'
	echoInColor
	installJava11
	echo ''
fi


if [[ $OH2UPDATE == "y" ]]; then
	# Upgrade from openHAB2 to openHAB testing (3.2.0Mx)
	DISPLTEXT='* Purging openHAB...'
	echoInColor
	removeOpenHAB
	DISPLTEXT='* Install openHAB testing (3.2.0Mx)...'
	echoInColor
	backupOpenhabFiles
	sudo apt purge --assume-yes openhab2
	installOpenhab3
	restoreOpenhabFiles
	sudo chown --recursive openhab:openhab /etc/openhab /var/lib/openhab /var/log/openhab /usr/share/openhab
	sudo chmod --recursive ug+wX /opt /etc/openhab /var/lib/openhab /var/log/openhab /usr/share/openhab
	echo ''
fi

if [[ $OH3UNTEST == "y" ]]; then
	# Remove unstable version and install openHAB testing (3.2.0Mx)
	#DISPLTEXT='* Purging openHAB...'
	#echoInColor
	#removeOpenHAB3
	DISPLTEXT='* Install openHAB testing (3.2.0Mx)...'
	backupOpenhabFiles
	installOpenhab3
	restoreOpenhabFiles
	sudo chown --recursive openhab:openhab /etc/openhab /var/lib/openhab /var/log/openhab /usr/share/openhab
	sudo chmod --recursive ug+wX /opt /etc/openhab /var/lib/openhab /var/log/openhab /usr/share/openhab
	echo ''
fi

if [[ $OH3UPDATE == "y" ]]; then
	# Remove stable version and install openHAB testing (3.1.0Mx)
	DISPLTEXT='* Purging openHAB...'
	echoInColor
	backupOpenhabFiles
	removeOpenHAB3
	DISPLTEXT='* Install openHAB testing (3.2.0Mx)...'
	echoInColor
	installOpenhab3
	restoreOpenhabFiles
	sudo chown --recursive openhab:openhab /etc/openhab /var/lib/openhab /var/log/openhab /usr/share/openhab
	sudo chmod --recursive ug+wX /opt /etc/openhab /var/lib/openhab /var/log/openhab /usr/share/openhab
	echo ''
fi

if [[ $OH == "none" ]]; then
	# Install openHAB testing (3.1.0M2)
	DISPLTEXT='* Install openHAB testing (3.2.0Mx)...'
	echoInColor
	backupOpenhabFiles
	installOpenhab3
	echo ''
fi

DISPLTEXT='* Copy Qbus JAR to openHAB...'
echoInColor
copyJar
echo ''

DISPLTEXT='* Starting Qbus services'
echoInColor
startQbus
echo ''

DISPLTEXT='* Creating setctd.sh'
echoInColor
createChangeSettings
echo ''

DISPLTEXT='* Cleaning up...'
echoInColor
sudo rm -R /tmp/qbus > /dev/null 2>&1
sudo rm -R /tmp/openhab2 > /dev/null 2>&1
sudo rm -R /tmp/openhab > /dev/null 2>&1
sudo rm -R ~/QbusOH3-Install > /dev/null 2>&1
echo ''

DISPLTEXT='* Starting openHAB...'
echoInColor

case $OH in
	OH2)
		DISPLTEXT='  - We have removed openHAB2 and installed the testing version of openHAB. We made a back-up of your files and restored them. In case someting went wrong, you can find your backups in /tmp/openhab2.'
		echoInColor
		;;
	OH3Unstable)
		DISPLTEXT='  - We have update openHAB to the testing version. We made a back-up of your files, if they are missing you can find them in /tmp/openhab.'
		echoInColor
		DISPLTEXT='  - Since we have installed a new JAR, the cache needs to be cleaned.'
		echoInColor
		echo ''
		;;
	OH3Stable)
		DISPLTEXT="  - We have update openHAB to the testing version. We made a back-up of your files, if they are missing you can find them in /tmp/openhab."
		echoInColor
		DISPLTEXT='  - Since we have installed a new JAR, the cache needs to be cleaned.'
		echoInColor
		echo ''
		;;
	OH3Testing)
		DISPLTEXT='  - Since we have installed a new JAR, the cache needs to be cleaned.'
		echoInColor
		;;
	none)
		DISPLTEXT='  - openHAB is installed, please hold on while we start openHAB...'
		echoInColor
		;;
esac

sudo systemctl daemon-reload > /dev/null 2>&1
sudo systemctl enable openhab.service > /dev/null 2>&1
sudo systemctl stop openhab.service > /dev/null 2>&1
sudo openhab-cli clean-cache
sudo systemctl start openhab.service > /dev/null 2>&1
DISPLTEXT='  !!! openHAB is restarting, but because we cleaned the cache this will take much longer than usual. Please be patient !!!'
echoInColor
echo ''
		
echo ''


if [[ $INSTSAMBA == "y" ]]; then
	DISPLTEXT='* Install SMB...'
	echoInColor
	installSamba
	DISPLTEXT='- Enter a password for the SMB share for the user openhab & repeat it (attention: the password will not be shown): '
	echoInColor
	sudo smbpasswd -a openhab
	echo ''
fi

DISPLTEXT='The installation is finished now. To make sure everything is set up correctly and to avoid problems, we suggest to do a reboot.'
echoInColor

echo ''

read -p "$(echo -e $YELLOW"Do you want to reboot now? (y/n) " $NC)" REBOOT

if [[ $REBOOT == "y" ]]; then
	DISPLTEXT='Rebooting the system...'
	echoInColor
	sudo reboot
else
	DISPLTEXT='You choose to not reboot your system. If you run into problems, first trys to reboot!'
	echoInColor
fi


