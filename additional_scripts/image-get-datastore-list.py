#!/bin/python3

import os
import xml.etree.ElementTree as ET

oneimage = os.popen("oneimage list --xml")

tree = ET.fromstring(oneimage.read())

#print(tree.tag)

for image in tree.findall('./IMAGE'):
    imageid = image.find('./ID')
    print(imageid.text)
    is_persistent = image.find('./PERSISTENT')
    if is_persistent.text == '1':
        continue
    for vmid in image.findall('./VMS/ID'):
        print(imageid.text+" "+vmid.text)

