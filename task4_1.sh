#!/bin/bash

BSN=(`dmidecode -s baseboard-serial-number`)
if [ "$BSN" = "" ];then
BSN=Unkown
fi


SSN=(`dmidecode -s system-serial-number`)
if [ "$SSN" = "" ];then
SSN=Unkown
fi
slog=./task4_1.out

function main
{


echo "--- HARDWARE ---"
echo "CPU "`cat /proc/cpuinfo | grep "model name" | sed -n 1p | grep -oP '(?=:).*'`
echo "RAM: "`free | grep Mem | awk '{print $2}'` "KB"
echo "Motherboard: "`dmidecode -s baseboard-manufacturer`" "`dmidecode -s baseboard-product-name`" "`dmidecode -s baseboard-version` $BSN
echo "System serial number: " $SSN
echo "--- SYSTEM ---"
echo "OS Distribution: "`lsb_release -d --short`
echo "Kernel version: "`uname -r`
echo "Installation date: "`cat /var/log/dpkg.log | grep "install linux-firmware" | awk '{print $1}'`
echo "Hostname: "`hostname`
echo "Uptime: "`uptime -p | awk '{print $2,$3,$4,$5,$6,$7,$8}' `
echo "Processes running: "`ps | sed -n 6p | awk '{print $1}'`
who=(`who | awk '{print $1}'`)
echo "Users logged in: ${#who[*]}"
echo "--- NETWORK ---"
for NEWIF in `ip address | awk '/mtu/{print $2}'`
do
NEWIP=(`ip address show "${NEWIF[$i]}" | awk '/inet /{print $2}' | xargs`)
if [ -z  "$NEWIP" ];
then
echo  "${NEWIF[$i]} -"
else
echo  "${NEWIF[$i]}" `ip address show "${NEWIF[$i]}" | awk '/inet /{print $2}' | xargs | sed 's/\ /, /g'`
fi
done
}



main 2>&1 | tee $slog
