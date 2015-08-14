#!/bin/bash

ssh 10.10.0.15 'sudo zfs list' | grep "cloud/opennebula/persistent/lv-one-" | awk '{ print $1 }' | sed 's/cloud\/opennebula\/persistent\/lv-one-//' | sed 's/-/ /'

