#!/bin/bash
# Usage: dropoff.sh "user@dest.com"

rsync -avh --exclude='**/.*' ../eecs318-fall2015 "$1:~/"
