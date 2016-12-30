#! /bin/bash

ls ~/Pictures/bg/*.jpg | sort -R | tail -1 | xargs /usr/bin/feh --bg-scale
