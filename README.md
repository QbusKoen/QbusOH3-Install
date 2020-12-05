# OpenHAB3Qbus

## Install
The provided script installs everything that is needed to enable communication between openHAB and the Qbus controller. 
The script speaks for itself and installs some programs that may not be needed by you. You can delete them to your needs.

This is the location of the files that are downloaded by the script if you want to manually install them:
https://github.com/QbusKoen/QbusOH3

Because the Client and Server are .net applications Mono is installed to make these programs run on a Linux system (Raspberry Pi). If you are running openHAB in a Windows environment you can safely delete this section.

Then the script will download the files from https://github.com/QbusKoen/QbusOH3. Fot the moment, a JAR file is included until the binding is released by openHAB.

After that the scripts installs Java JDK 11 which is needed by openHAB3 (if it is not installed)

Then the correct rights are set for certain folders and the JAR file is copied to the correct location, based on a Linux installation.

At this point we create 2 service files wich will run the QbusClient and QbusServer applications.

Now it is time to start the Qbus applications.

## Update
A second script, update.sh is included.
You can simply run this script when a new version of QbusClient, QbusServer or openHAB-JAR is available.
The script will
- Download the new files
- Replaces JAR files
- Restarts QbusClient and QbusServer
- Stops, clean cache and restart openHAB

Please be patient after updating. Since we clear the openHAB cache it will take some time to start the first time.

Rem: Sometimes a reboot is required. So if you run into trouble after the update, first try a reboot.

