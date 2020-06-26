#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

mv rapport.txt rapports/$(date +"%Y-%m-%d").txt

touch rapport.txt

