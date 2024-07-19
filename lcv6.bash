clear;
echo "-------------------------------------------------------------------------------------------";
echo "|  Welcome to the 66 bit TTD Pool installer script for Linux.                             |";
echo "|  With this script you can configure a Clore.AI instance with up to 14 Nvidia GPUs.      |";
echo "|  It should work with all GPUs Clore has available.                                      |";
echo "|  More information will be displayed when the script finishes.                           |";
echo "|  If you encounter any problems please contact me in the telegram chat.                  |";
echo "|                                                                                         |";
echo "|  Thanks and happy hunting Chris Zahrt                                                   |";
echo "|                                                                                         |";
echo "|  Press enter to continue.                                                               |";
echo "-------------------------------------------------------------------------------------------";
read AnyKey
clear;
apt-get update;
apt-get install -y joe;
apt-get install -y zip;
apt-get install -y screen;
apt-get install -y curl libcurl4
clear;
ClientFile="ttdclientVS66.6-VS1.18-Lin22.04cu12.3.zip"
echo "We are going to use $ClientFile.";
wget https://github.com/Orionsz/ttdv66/raw/main/$ClientFile -O $ClientFile
unzip $ClientFile;
cd ttdclientVS66.6-VS1.18-Lin22.04cu12.3;
chmod 755 ttdclientVS66.4 vanitysearch;
cd ..;
clear;
echo "Rig name? (ex: 4090 or Rig1 or keycrushertothemaxXL)";
read GPUName;
echo "How many GPUs? (1-14)";
read GPUCount;
echo "(1) for Random (2) for Sequential";
read ScanMode;
if [[ $ScanMode -eq 2 ]]
then
    GPURanges="seq";
else
    echo "How many ranges to work at one time per GPU? (1-16)";
    read GPURanges
fi
UserName="1btcforme";
BTCAddress="bc1qx343pleeucne86pwjfeyc2qfarmayhsggpys3u";
echo "Configuring this instance for $GPURanges range(s) each on $GPUCount $GPUName GPU(s) for user $UserName.";
for (( n=1; n<=$GPUCount; n++ ))
do
echo "Setting up GPU $n";
mkdir v$(($n-1));
cp ttdclientVS66.6-VS1.18-Lin22.04cu12.3/* v$(($n-1));
cd v$(($n-1));
sed -i "1s/.*/$UserName.Clore-$GPUName-$(($n-1)),$BTCAddress/" settings.ini;
sed -i "2s/.*/-t 0 -gpu -gpuId $(($n-1))/" settings.ini;
sed -i "5s/.*/$GPURanges/" settings.ini;
screen -dmS "v$(($n-1))" ./ttdclientVS66.4;
cd ..;
echo "cd v$(($n-1))" >> go
echo "screen -dmS "v$(($n-1))" ./ttdclientVS66.4" >> go
echo "cd .." >> go
echo "sleep 1" >> go
sleep 1
done
chmod 755 go;
echo "-------------------------------------------------------------------------------------------";
echo "NAPRAVEN OT DAKO SPECIALNO ZA MINKO HAKERA";
echo "-------------------------------------------------------------------------------------------";
echo "|  Config is complete.  Your ttdclient instances should now be running.                   |";
echo "|  Enter 'screen -list' to see the instances.                                             |";
echo "|  Enter 'screen -r v0' to connect to an instance. (v0 is the instance name from -list)   |";
echo "|  When connected to an instance press contrl-a then d to drop back out of the instance.  |";
echo "|  Enter 'nvidia-smi' to see gpu load and power consumption.                              |";
echo "|  You can close this connection and the instance(s) will continue running.               |";
echo "|  If the rig restarts you can restart the screen session(s) with './go'.                 |";
echo "|  MINKO SHTE IZKURTI CLORETO                                                              |";
echo "-------------------------------------------------------------------------------------------";
