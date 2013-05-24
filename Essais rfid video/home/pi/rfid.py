#!/usr/bin/env python

import usb.core
import usb.util
import time
import os

print "RFID APP"

os.popen("sudo chmod a+rw /dev/vchiq")

vendorid = 0x0c27
productid = 0x3bfa

# find our device by id
device = usb.core.find(idVendor=vendorid, idProduct=productid)
if device is None:
    raise Exception('Could not find USB Card Reader')

# remove device from kernel, this should stop
# reader from printing to screen and remove /dev/input
if device.is_kernel_driver_active(0):
    try:
        device.detach_kernel_driver(0)
    except usb.core.USBError as e:
        raise Exception("Could not detatch kernel driver: %s" % str(e))

# load our devices configuration
try:
    device.set_configuration()
    device.reset()
except usb.core.USBError as e:
    raise Exception("Could not set configuration: %s" % str(e))

# get device endpoint information
endpoint = device[0][(0,0)][0]

while True:
    id = ''
    while True:
        swiped = False
        datalist = []
        while True:
            try:
                results = device.read(endpoint.bEndpointAddress, endpoint.wMaxPacketSize, timeout=15)
                datalist.append(results)
                swiped = True

            except usb.core.USBError as e:
                if e.args[1] == 'Operation timed out' and swiped:
                    break # timeout and swiped means we are done

        # create a list of 8 bit bytes and remove
        # empty bytes
        ndata = []
        for d in datalist:
            if d.tolist() != [0, 0, 0, 0, 0, 0, 0, 0]:
                ndata.append(d.tolist())

        sdata = ''
        # parse over our bytes and create string to final return
        for n in ndata:
            sdata += str(n[2])

        id += sdata
        if sdata == '': break

    print
    print time.strftime('%d/%m/%y %H:%M:%S',time.localtime())
    print 'Id Card = '
    print id

    media = ''
    if id == '3039303734363237353832540':
        media = "/home/pi/media/avatar.mov"
    elif id == '313739393034373839363735540':
        media = "/home/pi/media/Flo-Rida-Whistle.mp4"

    if media != '':
        commande = "omxplayer -o hdmi " + media
        os.popen(commande)