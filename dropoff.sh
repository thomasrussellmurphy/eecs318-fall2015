#!/bin/bash
# Usage: dropoff.sh "user@dest.com"

rsync -avh --exclude='**/.DS_Store' ../eecs318-fall2015 "$1:~/"
