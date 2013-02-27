#!/bin/sh

host=$1
script=$2

set -e

scp "$script" $host:/tmp
ssh $host "/tmp/$script"

