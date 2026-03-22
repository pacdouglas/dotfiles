#!/usr/bin/env bash

# Date com icone para polybar
# Click abre gsimplecal

date_str=$(date '+%a %d %H:%M')
echo "%{T2} %{T-}$date_str"
