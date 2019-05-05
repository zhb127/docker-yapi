#!/bin/bash

lockPath="/yapi/init.lock"

cd /yapi/vendors

if [ ! -f "$lockPath" ]
then
  node server/install.js
  node server/app.js
else
  node server/app.js
fi
