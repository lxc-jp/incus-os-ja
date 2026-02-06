#!/bin/bash
if [ $# -ne 1 ]; then
  >&2 echo Usage: $0 upstream_commit
  exit 1
fi
git restore --source=$1 -- \
  COPYING \
  Makefile \
  README.md \
  app-build \
  incus-osd \
  mkosi.conf \
  mkosi.extra \
  mkosi.images \
  mkosi.packages \
  mkosi.repart \
  mkosi.sandbox \
  mkosi.version \
  patches \
  scripts \
  test
