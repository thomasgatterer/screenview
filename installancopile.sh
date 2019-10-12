apt-get update
apt-get install lazarus

# wo tut r die repos hin? sind die dann gesammelt unter dem nwbox repo 
git clone https://github.com/thomasgatterer/screenview
cd screenview

lazbuild vnc03.lpi
## https://wiki.lazarus.freepascal.org/Using_the_LCL_without_Lazarus

das ausführbare Programm vnc3 gehört dann (verlinkt) auf den Desktop des LehrerInnen PCs

die Clients sind in einem ini 

## an den clients muss installiert sein und laufen:
x11vnc -auth guess -display :0 -forever

