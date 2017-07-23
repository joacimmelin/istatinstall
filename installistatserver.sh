#A very simple Bash script to download the iStatServer, install all 
#packages needed, compile the software, email you the config with 
#the unique access code and then add istatserver to /etc/rc.local. 
#This script is ugly and written by an amateur (me) but it gets the job done. 

#Download the software
wget https://s3.amazonaws.com/bjango/files/istatserverlinux/istatserver-3.01.tar.gz

#unpack the software
tar -xvf istatserver-3.01.tar.gz

#go to the install directory
cd istatserver-3.01/

#install all packets needed for compile. 
yum install gcc-c++ autoconf automake libxml2-devel openssl-devel sqlite-devel -y

#auto generation
./autogen

#configure
./configure

#make the software
make

#make install
make install

#add istatserver to /etc/rc.local because we are lazy like that. 
echo "/usr/local/bin/istatserver -d" >> /etc/rc.local

#start the istatserver as a daemon
/usr/local/bin/istatserver -d

#Copy the configuration to /root
cp /usr/local/etc/istatserver/istatserver.conf /root/

#Email the config to a preset email adress for easier management 
#when adding several servers to the iStat client. 
#This assumes your server(s) are setup to route email properly. 
echo "Please find enclosed file with iSTATSERVER info" | mail -s "iStatServer install on $HOSTNAME" your@emailadress.tld -A /root/istatserver.conf
