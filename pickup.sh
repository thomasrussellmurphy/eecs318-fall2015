#!/bin/bash
# Usage: dropoff.sh "user@dest.com"

rsync -avh --update "$1:~/eecs318-fall2015/" ./
