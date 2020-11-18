# OpenHAB2Qbus

The provided script installs everything that is needed to enable communication between openHAB and the Qbus controller. 
The script speaks for itself and installs some programs that may not be needed by you. You can delete them to your needs.

This is the location of the files that are downloaded by the script if you want to manually install them:
https://github.com/QbusKoen/QbusOpenHab

Because the Client and Server are .net applications Mono is installed to make these programs run on a Linux system (Raspberry Pi). If you are running openHAB in a Windows environment you can safely delete this section.

Then the script will download the files from the Qbus/openHAB repository. Fot the moment, a JAR file is included until the binding is released by openHAB.

I had problems enabeling the cloud connector for openHAB because there was an older version of Java installed on my Raspberry pi. I've spend some time finding the correct Java installer, so i decided to include this in the repository. Again, delete it if you don't need it.

After that it installs the prerequiaries for openHAB, openHAB itself and all the bindings.

Then the correct rights are set for certain folders and the JAR file is copied to the correct location, based on a Linux installation.

At this point we create 2 service files wich will run the QbusClient and QbusServer applications.

Now it is time to start the Qbus applications, followed by openHAB.

Finnaly Samba Share is installed to easaly edit the openHAB files on a Windows machine. This installer will ask you a password on the end to protect the Shared folder.

An additional script (setctd.sh) is included in case you change the ip address, username, password or serial nr of the controller. This script will adjust the settings in the services and restart them.

