#!/bin/bash

cd $1

/home/developer/flutter/bin/flutter build web

cp -a build/web/. /var/www/html
