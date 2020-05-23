# Domoticz-Docker
Build a Docker image for running Domoticz including OpenZwave 1.6 on x86.
My main purpose is to run this on my Synology NAS.

may 22nd 2020: succesfully build Domoticz 2020.2 (12077) without the need to use the external libs repository. (External Libs were required for 2020.1 build, otherwise MQTT was crashing). 

Running 2020.2 now for 10 hours. I upgraded from Domoticz 4.10603 Beta, make a backup before you upgrade.

Because of the OpenZwave upgrade to 1.6 only the always powered Zwave devices were recognized. The battery powered devices needed a refresh (Click on the + sign next to the device in the config. It will do a node refresh. The big trick is to wake up your zwave device within 5 seconds by pushing the device button on your device). I succesfully added my NeoCoolcam door/window sensors flawlessly with this trick.

