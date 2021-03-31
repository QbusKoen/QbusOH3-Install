#!/bin/bash

# ============================== Define variables ==============================
OH2UPDATE=''
OH3UNTEST=''
OH3UPDATE=''
QBUSNEW=''
INSTMONO=''
ISAMBA=''
USERVAR=''
PASSVAR=''
IPVAR=''
SNVAR=''
JAVA=''

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

installMono(){
        spin &
        SPIN_PID=$!
        trap "kill -9 $SPIN_PID" `seq 0 15`
        sudo apt-get --assume-yes install mono-runtime mono-vbnc mono-complete > /dev/null 2>&1
        kill -9 $SPIN_PID
}

downloadQbus(){
        spin &
        SPIN_PID=$!
        trap "kill -9 $SPIN_PID" `seq 0 15`
        git clone https://github.com/QbusKoen/QbusOH3 /tmp/qbus> /dev/null 2>&1
        kill -9 $SPIN_PID
}

installJava11(){
        spin &
        SPIN_PID=$!
        trap "kill -9 $SPIN_PID" `seq 0 15`
        sudo apt-get --assume-yes install openjdk-11-jdk-headless
        kill -9 $SPIN_PID
}

copyJar(){
        sudo rm /usr/share/openhab/addons/org.openhab.binding.qbus.* /tmp/qbus> /dev/null 2>&1
        sudo cp /tmp/qbus/JAR/org.openhab.binding.qbus-3.1.0-SNAPSHOT.jar /usr/share/openhab/addons/ /tmp/qbus> /dev/null 2>&1
}

createChangeSettings(){
        spin &
        SPIN_PID=$!
        trap "kill -9 $SPIN_PID" `seq 0 15`
        sudo rm /tmp/qbus/setctd.sh > /dev/null 2>&1

        echo "#!/bin/bash" | sudo tee -a /tmp/openhab/setctd.sh > /dev/null 2>&1
        echo "" | sudo tee -a /tmp/openhab/setctd.sh > /dev/null 2>&1
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
        echo "read -sp 'Enter the password of your controller (attention - hidden chars) - no password? Just press enter: ' PASSVAR" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "echo -n 'Enter the password of your controller: '" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "unset password;" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "while IFS= read -r -s -n1 pass; do" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "  if [[ -z $pass ]]; then" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "   echo" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "   break" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "  else" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "   echo -n '*'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "   PASSVAR+=$pass" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "  fi" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "done" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "if [[ $PASSVAR == '' ]]; then" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "  PASSVAR='none'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "fi" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
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
        echo "echo 'ExecStart= mono /usr/bin/qbus/qbusclient/QbusClient.exe '$IPVAR' '$USERVAR' '$PASSVAR' '$SNVAR' 50' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "echo 'Restart=always' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "echo 'StandardOutput=file:/var/log/qbus/qbusclient.log' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "echo 'StandardError=file:/var/log/qbus/qbusclient_error.log' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "echo '[Install]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "echo 'WantedBy=multi-user.target' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1

        echo "sudo systemctl daemon-reload" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
        echo "sudo systemctl restart qbusclient.service" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1

        sudo cp /tmp/qbus/setctd.sh ~/setctd.sh
        sudo chmod +x ~/setctd.sh
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
        sudo cp -R /tmp/qbus/QbusClient/* /usr/bin/qbus/qbusclient/
        sudo cp -R /tmp/qbus/QbusServer/* /usr/bin/qbus/qbusserver/

        # Modify config file
        sudo sed -i "s|<value>.\+</value>|<value>/usr/bin/qbus/qbusclient/</value>|g" /usr/bin/qbus/qbusclient/QbusClient.exe.config

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
        echo 'ExecStart= mono /usr/bin/qbus/qbusclient/QbusClient.exe '$IPVAR' '$USERVAR' '$PASSVAR' '$SNVAR' 50' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
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
        if [[OH="OH2"]]; then
                sudo cp -R /etc/openhab2 /tmp/openhab2
        else
                sudo cp -R /etc/openhab /tmp/openhab
        fi
}

restoreOpenhabFiles(){
        if [[OH="OH2"]]; then
                sudo cp -R /tmp/openhab2 /etc/openhab
        else
                sudo cp -R /tmp/openhab /etc/openhab
        fi
}

installSamba(){
        spin &
        SPIN_PID=$!
        trap "kill -9 $SPIN_PID" `seq 0 15`
        sudo apt-get --assume-yes install samba samba-common-bin
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
        wget -qO - 'https://bintray.com/user/downloadSubjectPublicKey?username=openhab' | sudo apt-key add -
        sudo apt-get install apt-transport-https
        echo 'deb https://openhab.jfrog.io/artifactory/openhab-linuxpkg testing main' | sudo tee /etc/apt/sources.list.d/openhab.list
        sudo apt-get --assume-yes update && sudo apt-get --assume-yes install openhab
        kill -9 $SPIN_PID
}


# ============================== Start installation ==============================
echo "   ____  _                 ___                           _    _          ____  "
echo "  / __ \| |               |__ \                         | |  | |   /\   |  _ \ "
echo " | |  | | |__  _   _ ___     ) |   ___  _ __   ___ _ __ | |__| |  /  \  | |_) |"
echo " | |  | | '_ \| | | / __|   / /   / _ \| '_ \ / _ \ '_ \|  __  | / /\ \ |  _ < "
echo " | |__| | |_) | |_| \__ \  / /_  | (_) | |_) |  __/ | | | |  | |/ ____ \| |_) |"
echo "  \___\_\_.__/ \__,_|___/ |____|  \___/| .__/ \___|_| |_|_|  |_/_/    \_\____/ "
echo "                                       | |                                     "
echo "                                       |_|                                     "
echo ""
echo "Relaese date 28/03/2021 by ks@qbus.be"
echo ""
echo 'Welcom to the Qbus2openHAB installer.'
echo "At the current moment the openHAB binding for Qbus is being checked by openHAB developpers, so you won't find the binding in the repository yet."
echo "Therefore we will install he current JAR file so you can use the binding anyway, you just don't have to install it from the Bindings list. It will be pre-installed."
echo "Since we are developping for the latest release of openHAB, the testing (3.1.0M2) version, we will install this version. If you already have an openHAB setup, then "\
"we will remove the stable version and change it with the testing version."
echo ""

# ---------------- Check for Mono -----------------------
echo "Checking Mono..."
MONO=$(which mono 2>/dev/null)
if [[ $MONO != "" ]]; then
        echo 'Mono is already installed.'
else
        read -p 'We did not detect Mono on your system. For the moment the Qbus client/server is based on .net. Therefore Mono is neccesary to run the client/server. Do you agree to install Mono (y/n)?' INSTMONO
        if [[ $INSTMONO == "n" ]]; then
                echo 'Sorry, if you do not install Mono, you can not use the Qbus Client/Server application.'
                exit 1
        fi
fi
echo ''

# ---------------- Check for Qbus Client/Server -----------------------
echo 'Checking Qbus client/server...'
QBUS=$(ls /lib/systemd/system/qbusclient.service 2>/dev/null)
if [[ $QBUS != "" ]]; then
        QBUS2=$(ls /usr/bin/qbus/ 2>/dev/null)
        if [[ $QBUS2 != "" ]]; then
                echo 'You already have Qbus client and server installed. The files will be updated.'
        else
                echo 'We have detected the previous version of the Qbus client/server. This version will be removed and the newest will be installed. The directory ~/QbusOpenHab will no longer be used. '\
                'The Qbus Client/Server application will be installed in /usr/bin/qbus/. We will try to remove ~/QbusOpenHab if this fails, please remove the directory.'
        fi
else
        echo 'Qbus client/server is not found on your sytem. We will install this'
fi
echo ''

# ---------------- Ask Qbus credentials  -----------------------
echo 'To communicate with your controller, it is necessary that the SDK (DLL) option is enabled. (see https://openhab-wiki.qbus.be/nl/inleiding)'
read -p 'Enter username of your controller: ' USERVAR
echo -n 'Enter the password of your controller: '

unset password;
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

read -p 'Enter the ip address of your controller: ' IPVAR
read -p 'Enter the serial number of your controller: ' SNVAR
echo ''

# ---------------- Check for Samba -----------------------
echo 'Checking SMB...'
SAMBA=$(ls /etc/samba/ 2>/dev/null)
if [[ $SAMBA != "" ]]; then
        echo '- Samba Share is installed.'
        SMB=$(cat /etc/samba/smb.conf)

    if [[ $SMB =~ "path=/etc/openhab2" ]]; then
      echo '- Samba Share is configured for openhab2, changing to openhab...'
          sed -i "s|path=/etc/openhab2|path=/etc/openhab|g" /etc/samba/smb.conf
        fi

        SMBUSER=$(sudo pdbedit -L 2>/dev/null)
        if [[ $SMBUSER =~ "openhab" ]]; then
      echo '- openhab user configured for SMB'
        else
          echo '- openhab user is not configured for Samba Share.'
          echo '- Enter a password for the SMB share for the user openhab & repeat it: '
          sudo smbpasswd -a openhab
        fi
else
        echo '- We did not detect Samba share on your system. You don not really need SMB, but it makes it easier to configure certain openHAB things. Do you agree to install Samba share (y/n)?' INSTSAMBA
        if [[ $INSTSAMBA != "n" ]]; then
                echo '- You choose to not install SMB. This means you have to configure certain openHAB things on this device.'
        fi
fi

# ---------------- Check Java JDK 11 -----------------------
JAVA=$(ls java-11-openjdk 2>/dev/null)
if [[ $JAVA != "" ]]; then
        echo 'JAVA JDK 11 is not installed on your system. This is required for the correct functionality of openHAB. Do you agree to install JAVA JDK 11 (y/n)?' INSTJAVA
        if [[ $INSTJAVA == "n" ]]; then
                echo '- You choose to not install JAVA, You may have problems running openHAB.'
        fi
fi


# ---------------- Check openHAB -----------------------
checkOH

case $OH in
        OH2)
                read -p '- We have detected openHAB2 running on your device. The Qbus Binding is developped for the newest version of openHAB (3).'\
                'For this moment the binding does not work with te stable release of openHAB (3.0.1), the testing realse (3.1.0M2) should be used.'\
                'Do you agree that we remove openHAB2 and install the testing relaese of openHAB? (y/n)' OH2UPDATE
                ;;
        OH3Unstable)
                read -p '- We have detected openHAB running the unstable (3.1.0-SNAPSHOT) version. '\
                'The Qbus Binding will work on this version, but you should be aware that there can be bugs in openHAB itself. '\
                'Do you want to keep this version? (y) or do you want to install the testing realse (3.1.0M2) which is more stable? (n)' OH3UNTEST
                ;;
        OH3Testing)
                echo '- We have detected openHAB running the testing (3.1.0M2) version. This version is compatible with the Qbus Binding.'
                ;;
        OH3Stable)
                read -p '- We have detected openHAB running the stable version (3.0.1). '\
                'For this moment the binding does not work with te stable release of openHAB (3.0.1), the testing realse (3.1.0M2) should be used. '\
                'Do you agree that we remove the main release and install the testing relaese of openHAB? (y/n)' OH3UPDATE
                ;;
        None)
                echo '- We did not detected openHAB running on your system. For this moment the binding does not work with te stable release of openHAB (3.0.1), the testing realse (3.1.0M2) will be installed.'
                ;;
esac


if [[ $INSTMONO == "y" ]]; then
        echo '* Installing Mono...'
        installMono
fi

echo '* Downloading Qbus client and server...'
downloadQbus

echo '* Install Qbus client and server...'
installQbus

if [[ $INSTJAVA == "y" ]]; then
        echo '* Installing Java JDK 11...'
        installJava11
fi


if [[ $OH2UPDATE == "y" ]]; then
        # Upgrade from openHAB2 to openHAB testing (3.1.0M2)
        echo '* Install openHAB...'
        backupOpenhabFiles
        sudo apt purge --assume-yes openhab2
        installOpenhab3
        restoreOpenhabFiles
fi

if [[ $OH3UNTEST == "y" ]]; then
        # Remove unstable version and install openHAB testing (3.1.0M2)
        echo '* Install openHAB...'
        backupOpenhabFiles
        installOpenhab3
        restoreOpenhabFiles
fi

if [[ $OH3UPDATE == "y" ]]; then
        # Remove stable version and install openHAB testing (3.1.0M2)
        echo '* Install openHAB...'
        backupOpenhabFiles
        installOpenhab3
        restoreOpenhabFiles
fi

if [[ $INSTSAMBA == "y" ]]; then
        echo '* Install SMB...'
        installSamba
        echo '- Enter a password for the SMB share for the user openhab & repeat it: '
        sudo smbpasswd -a openhab
fi

echo '* Copy Qbus JAR to openHAB...'
copyJar

echo '* Starting Qbus services'
startQbus

echo '* Creating setctd.sh'
createChangeSettings

echo '* Cleaning up...'
sudo rm -R /tmp/qbus > /dev/null 2>&1
sudo rm -R ~/QbusOpenHab/ > /dev/null 2>&1

echo '* Starting openHAB...'
case $OH in
        OH2)
                echo "- We have removed openHAB2 and installed the testing version of openHAB. We made a back-up of your files and restored them. In case someting went wrong, you can find your backups in /tmp/openhab2."
                ;;
        OH3Unstable)
                echo "- We have update openHAB to the testing version. We made a back-up of your files, if they are missing you can find them in /tmp/openhab."
                echo '- Since we have installed a new JAR, the cache needs to be cleaned. Please select yes to clean the cache'
                sudo /bin/systemctl stop openhab.service
                sudo openhab-cli clean-cache
                sudo /bin/systemctl start openhab.service
                echo 'openHAB is restarting, but because we cleaned the cache this will take much longer than usual. Please be patient.'
                ;;
        OH3Stable)
                echo "- We have update openHAB to the testing version. We made a back-up of your files, if they are missing you can find them in /tmp/openhab."
                echo '- Since we have installed a new JAR, the cache needs to be cleaned. Please select yes to clean the cache'
                sudo /bin/systemctl stop openhab.service
                sudo openhab-cli clean-cache
                sudo /bin/systemctl start openhab.service
                echo 'openHAB is restarting, but because we cleaned the cache this will take much longer than usual. Please be patient.'
                ;;
        OH3Testing)
                echo '- Since we have installed a new JAR, the cache needs to be cleaned. Please select yes to clean the cache'
                sudo /bin/systemctl stop openhab.service
                sudo openhab-cli clean-cache
                sudo /bin/systemctl start openhab.service
                echo 'openHAB is restarting, but because we cleaned the cache this will take much longer than usual. Please be patient.'
                ;;
esac

echo ''
echo 'The installation is finished now. To make sure everything is set up correctly and to avoid problems, we suggest to do a reboot.'
read -p 'Do you want to reboot now? (y/n) ' REBOOT
if [[ $REBOOT == "y" ]]; then
        echo 'Rebooting the system...'
        sudo reboot
fi
