#!/bin/bash
set -e
clear
hostnamectl hostname hq-cli.au-team.irpo
timedatectl set-timezone Europe/Moscow
ip a
