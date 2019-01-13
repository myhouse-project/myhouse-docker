# myHouse #

Think of myHouse as a framework for collecting statistics and automating your house.
Configure the sensors you want to collect data from by leveraging the included plugins (e.g. to collect weather statistics, images from the Internet, your GPS position, data collected by MySensors, etc.).

What will be presented in the web interface is completely up to you. You can define your own modules, configure all the widgets and statistics that will be presented in the order you like the most. From the interface your actuators can be controlled as well.

You can also easily create rules to be automatically alerted whenever a specific situation is taking place. Notifications are both presented within the web interface, sent by e-mail and posted on a Slack channel of your choice.
A Slack bot allows also direct interaction in your natural language. It can reply to your questions, share with you statistics and charts or even control the actuators on your behalf

*myHouse Project Home Page: https://myhouse-project.github.io*

*myHouse on Docker: https://github.com/myhouse-project/myhouse-docker*

## Docker Image Features ##
* Based on Raspbian Jessie and including Raspberry Pi's most common utilities (e.g. raspistill, wiringpi, bluetooth, etc.)
* Delivers myHouse together with all the required and optional dependencies
* Includes an embedded Redis database and Mosquitto MQTT  (but it is recommended to be placed in independent containers in production)
* Includes rtl_433 binaries (https://github.com/merbanan/rtl_433)
* Provide out-of-the-box scripts to customize the container setup before starting myHouse (e.g. attaching a bluetooth speaker, setting the timezone, etc.)
* Support both ARM and x86 architectures

## How to Run It ##
* Create a directory called `conf` (that will be mapped into `/conf` inside the container) and copy in your own `config.json` file if you already have it. If no configuration file is provided (e.g. first time user) the example file will be loaded and the same will be copied into `/conf`. Edit it and and restart the container to apply the changes.
* If using the embedded redis database, create a directory called `data` (that will be mapped to `/data` inside the container),  where the database file will be written
* Optionally create a directory called `logs` (that will be mapped to `/logs` inside the container) where myHouse log files will be written
* If you need to perform any custom action before starting myHouse, create a directory called `setup` (that will be mapped to `/setup` inside the container) and create a file named `setup.sh` in it which will be executed inside the container before actually starting myHouse. Sample scripts for performing the most common actions (e.g. setting the timezone, connect a bluetooth speaker, etc.) are already included into the container (see the commented commands inside `setup.sh` on the docker project website https://github.com/myhouse-project/myhouse-docker)
* Run the docker image. You need to map port 80 for accessing myHouse web interface

### Example ###  
~~~
docker run --rm -p 80:80 -v $(pwd)/conf:/conf -v $(pwd)/data:/data myhouseproject/myhouse
~~~

### Caveats ###
* If you want to run a command inside the container, just add it at the end of your docker run command. E.g. if you want a shell inside the container, run `docker run myhouseproject/myhouse  bash`
* If you want to start the image at boot time, run it with the appropriate restart policy (e.g. `--restart always`)
* If you need to access any device on the host system (e.g. the serial port), either run in privileged mode (e.g. `--privileged`) or map the device (e.g. `-v /dev/ttyUSB0:/dev/ttyUSB0`)
* If you need to connect to a bluetooth device (e.g. a bluetooth speaker), run the network in host mode (e.g. `--net=host`)
* If running redis and/or mosquitto in independent container, pass along environmental variables to avoid starting the services inside the container as well  (e.g. `-e NO_REDIS=1` and `-e NO_MQTT=1`)
* if you need to review the container's operating system logs, start syslog in your custom setup script file (e.g. `/etc/init.d/rsyslog start`)
* if you need the embedded MQTT broker to be accessible from other services in the network, map port 1883 (e.g. `-p 1883:1883`)
* If you want to SSH into the container from your network, start the SSH server in your custom setup script (`/etc/init.d/ssh start`) and map port 22 (e.g. `-p 2222:22`)
* For running a specific version or the development version, add the tag at the end (e.g. `myhouseproject/myhouse:development`
* If running on a x86 architecture, binfmt-support on the host operating system is required (qemu-arm-static is already included into the image)
* If running the WirelessThings MessageBridge plugin you need to either run in host mode (e.g. `--net=host`) or expose port 50140/udp (e.g. -p 50140:50140/udp)

### Docker Compose ###
Especially when running the redis database in an independent container or if one of the scenarios above applies, providing all the command line arguments may become cumbersome. Docker compose can help in this situation, also for centralizing the configuration of all the containers.
A sample `docker-compose.yml` file is provided on https://github.com/myhouse-project/myhouse-docker. Customize the file based on your needs and run it with `docker-compose up -d`

## Tags ##
* [`latest`, `2.4`](https://github.com/myhouse-project/myhouse-docker/blob/master/Dockerfile)
* [`development`](https://github.com/myhouse-project/myhouse-docker/blob/development/Dockerfile)
