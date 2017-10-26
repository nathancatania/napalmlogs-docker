#!/bin/sh
envtpl --keep-template /usr/bin/napalm.tmpl -o /tmp/napalm.conf
napalm-logs --config-file /tmp/napalm.conf
