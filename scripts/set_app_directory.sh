#!/bin/bash
tar --exclude='node_modules' -czf /tmp/chessu.tar.gz -C /vagrant .

mkdir -p ~/chessu
tar -xzf /tmp/chessu.tar.gz -C ~/chessu