#!/bin/bash

spin()
{
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

echo "   ____  _                 ___                           _    _          ____  "
echo "  / __ \| |               |__ \                         | |  | |   /\   |  _ \ "
echo " | |  | | |__  _   _ ___     ) |   ___  _ __   ___ _ __ | |__| |  /  \  | |_) |"
echo " | |  | | '_ \| | | / __|   / /   / _ \| '_ \ / _ \ '_ \|  __  | / /\ \ |  _ < "
echo " | |__| | |_) | |_| \__ \  / /_  | (_) | |_) |  __/ | | | |  | |/ ____ \| |_) |"
echo "  \___\_\_.__/ \__,_|___/ |____|  \___/| .__/ \___|_| |_|_|  |_/_/    \_\____/ "
echo "                                       | |                                     "
echo "                                       |_|                                     "
echo ""

read -p 'Enter username of your controller: ' uservar
read -sp 'Enter the password of your controller: ' passvar
echo ''
read -p 'Enter the ip address of your controller: ' ipvar
read -p 'Enter the serial number of your controller: ' snvar

echo 'Please be patient while we set up your configuration.....'

echo 'Installing Mono ...'
spin &
SPIN_PID=$!
trap "kill -9 $SPIN_PID" `seq 0 15`
sudo apt-get --assume-yes install mono-runtime mono-vbnc mono-complete > /dev/null 2>&1
kill -9 $SPIN_PID

echo 'Downloading nesecary files from github...'
spin &
SPIN_PID=$!
trap "kill -9 $SPIN_PID" `seq 0 15`
git clone https://github.com/QbusKoen/QbusOH3 ~/QbusOpenHab3> /dev/null 2>&1
kill -9 $SPIN_PID

echo 'Installing Java v11...'
spin &
SPIN_PID=$!
trap "kill -9 $SPIN_PID" `seq 0 15`
sudo apt-get install openjdk-11-jdk-headless
kill -9 $SPIN_PID

echo 'Copy Qbus JAR file'
sudo rm /usr/share/openhab/addons/org.openhab.binding.qbus.*
sudo cp ~/QbusOpenHab3/JAR/org.openhab.binding.qbus-3.1.0-SNAPSHOT.jar /usr/share/openhab/addons/

echo 'Preparing Qbus services'
spin &
SPIN_PID=$!
trap "kill -9 $SPIN_PID" `seq 0 15`
echo '[Unit]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
echo 'Description=Client for Qbus communication' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
echo 'After=multi-user.target qbusserver.service' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
echo '[Service]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
echo 'Type=simple' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
echo 'ExecStart= mono ~/QbusOpenHab3/QbusClient/QbusClient.exe '$ipvar' '$uservar' '$passvar' '$snvar'' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
echo 'Restart=always' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
echo '[Install]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
echo 'WantedBy=multi-user.target' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1

echo '[Unit]' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
echo 'Description=Server for Qbus communication' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
echo 'After=multi-user.target' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
echo '' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
echo '[Service]' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
echo 'Type=simple' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
echo 'ExecStart= mono ~/QbusOpenHab3/QbusServer/QServer.exe' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
echo 'Restart=always' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
echo '' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
echo '[Install]' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
echo 'WantedBy=multi-user.target' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
kill -9 $SPIN_PID

echo 'Starting Qbus services'
spin &
SPIN_PID=$!
trap "kill -9 $SPIN_PID" `seq 0 15`
sudo systemctl daemon-reload > /dev/null 2>&1
sudo systemctl enable qbusserver.service > /dev/null 2>&1
sudo systemctl start qbusserver.service > /dev/null 2>&1
sudo systemctl enable qbusclient.service > /dev/null 2>&1
sudo systemctl start qbusclient.service > /dev/null 2>&1
kill -9 $SPIN_PID

echo 'Installing Samba Share'
sudo apt-get --assume-yes install samba samba-common-bin
spin &
SPIN_PID=$!
trap "kill -9 $SPIN_PID" `seq 0 15`
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

echo 'Enter a password for the SMB share & repeat it: '
sudo smbpasswd -a openhab
