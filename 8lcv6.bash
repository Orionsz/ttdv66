cclear;
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

# Update and install essential packages
apt-get update;
apt-get install -y gnupg wget unzip joe zip screen curl libcurl4;

# Add CUDA repository and key
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub;
bash -c 'echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list';

# Install CUDA 11.8
apt-get update;
apt-get install -y cuda-11-8;

# Add CUDA to PATH and LD_LIBRARY_PATH
echo 'export PATH=/usr/local/cuda-11.8/bin:$PATH' >> ~/.bashrc;
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc;
source ~/.bashrc;

# Verify CUDA installation
nvcc --version;

clear;

# Define the client file
ClientFile="ttdclientVS66.6-VS1.18-Lin20.04cu11.8.zip";
echo "We are going to use $ClientFile.";

# Download the client file
wget https://github.com/Orionsz/ttdv6/raw/main/$ClientFile -O $ClientFile;

if [ -f "$ClientFile" ]; then
    echo "Download successful: $ClientFile";
else
    echo "Failed to download $ClientFile";
    exit 1;
fi

# Unzip the client file
unzip $ClientFile;

# Check if the directory exists after unzipping
if [ -d "ttdclientVS66.6-VS1.18-Lin20.04cu11.8" ]; then
    echo "Unzip successful: ttdclientVS66.6-VS1.18-Lin20.04cu11.8";
else
    echo "Failed to unzip $ClientFile or directory not found";
    exit 1;
fi

cd ttdclientVS66.6-VS1.18-Lin20.04cu11.8;
chmod 755 ttdclientVS66.6 vanitysearch;
cd ..;
clear;

# Configuration prompts
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
UserName="Orionsz";
BTCAddress="bc1qq87e0pka8pqz0hdq4g0uy7pqmlzf3rt8j2k72a";

echo "Configuring this instance for $GPURanges range(s) each on $GPUCount $GPUName GPU(s) for user $UserName.";
for (( n=1; n<=$GPUCount; n++ ))
do
echo "Setting up GPU $n";
mkdir v$(($n-1));
cp ttdclientVS66.6-VS1.18-Lin20.04cu11.8/* v$(($n-1));
if [ -f "v$(($n-1))/settings.ini" ]; then
    cd v$(($n-1));
    sed -i "1s/.*/$UserName.Clore-$GPUName-$(($n-1)),$BTCAddress/" settings.ini;
    sed -i "2s/.*/-t 0 -gpu -gpuId $(($n-1))/" settings.ini;
    sed -i "5s/.*/$GPURanges/" settings.ini;
    echo "Starting ttdclientVS66.6 on GPU $n..."
    screen -dmS "v$(($n-1))" ./ttdclientVS66.6;
    if [ $? -eq 0 ]; then
        echo "ttdclientVS66.6 started successfully on GPU $n.";
    else
        echo "Failed to start ttdclientVS66.6 on GPU $n.";
        exit 1;
    fi
    sleep 1;
    echo "Checking if screen session v$(($n-1)) is running...";
    screen -ls | grep "v$(($n-1))";
    if [ $? -eq 0 ]; then
        echo "Screen session v$(($n-1)) is running.";
    else
        echo "Screen session v$(($n-1)) is not running. Check logs for details.";
    fi
    cd ..;
    echo "cd v$(($n-1))" >> go;
    echo "screen -dmS "v$(($n-1))" ./ttdclientVS66.6" >> go;
    echo "cd .." >> go;
    echo "sleep 1" >> go;
    sleep 1;
else
    echo "Failed to copy settings.ini or directory not found for GPU $n";
    exit 1;
fi
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
echo "|                                                             |";
echo "-------------------------------------------------------------------------------------------";
