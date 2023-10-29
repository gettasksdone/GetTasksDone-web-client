#!/bin/bash

cd $0

flutter build web

cp -a build/web/. /var/www/html
