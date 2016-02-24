#!/bin/sh

HCI_DEVICE=/dev/ttyHSL0
BLUETOOTH_SLEEP_PATH=/proc/bluetooth/sleep/proto
RFKILL=/usr/sbin/rfkill
HCI_INIT=/system/bin/hci_qcomm_init
HCI_ATTACH=/usr/sbin/hciattach
FIRMWARE_PATH=/persist
VENDOR=qualcomm
POWER_CLASS=2
LE_POWER_CLASS=2

BTS_DEVICE=
BTS_TYPE=
BTS_BAUD=
BTS_ADDRESS=
hcipid=
lastres=

##################################################

setprop ro.qualcomm.bt.hci_transport smd
setprop qcom.bt.dev_power_class 2
setprop qcom.bt.le_dev_pwr_class 2
# $RFKILL unblock bluetooth soft
# echo "info: $RFKILL unblock bluetooth soft"
echo "info: $HCI_INIT -d $HCI_DEVICE -e"
eval $($HCI_INIT -p $POWER_CLASS -P $LE_POWER_CLASS -d $HCI_DEVICE -e)
echo "info: extracted values are: $BTS_DEVICE : $BTS_TYPE : $BTS_BAUD : $BTS_ADDRESS"
lastres=$?

case $lastres in
  0)
  echo "info:  Bluetooth QSoC firmware download succeeded, $BTS_DEVICE $BTS_TYPE $BTS_BAUD $BTS_ADDRESS"
  setprop ro.qualcomm.bluetooth.opp true
  setprop ro.qualcomm.bluetooth.hfp true
  setprop ro.qualcomm.bluetooth.hsp true
  setprop ro.qualcomm.bluetooth.pbap true
  setprop ro.qualcomm.bluetooth.ftp true
  setprop ro.qualcomm.bluetooth.nap true
  setprop ro.bluetooth.sap true
  setprop ro.bluetooth.dun true
  MAXTRIES=5
  seq 1 $MAXTRIES | while read i ; do
    echo 1 > /sys/module/hci_smd/parameters/hcismd_set
    if [ -e /sys/class/bluetooth/hci0 ] ; then
      # found hci0, exit successfully
      echo "info: updating hcismd_set"
      echo "info: $HCI_ATTACH -t 5 -s $BTS_BAUD -f $FIRMWARE_PATH $HCI_DEVICE $VENDOR flow $BTS_ADDRESS"
      $HCI_ATTACH -t 5 -s $BTS_BAUD -f $FIRMWARE_PATH $HCI_DEVICE $VENDOR flow $BTS_ADDRESS &
      hcipid=$!
      echo "hcipid = $hcipid"
      echo "$hcipid" > /run/hciattach.pid
      lastres=0
      exit $lastres
    fi
    sleep 1
done
  ;;
  *) echo " Bluetooth QSoC firmware download failed" $lastres;
esac

exit $lastres
