#!/bin/bash
nginx
cd /root/app
source ~/.bashrc
bundle exec puma -C config/puma.rb