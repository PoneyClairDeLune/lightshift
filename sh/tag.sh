#!/bin/bash
git tag -a "$1" "$2" && git push origin "$1"
exit