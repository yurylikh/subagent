#!/bin/bash

cat << EOF
Container IP address is $(hostname -i).
Python interpreter version is $(python -V 2>&1 | cut -d$' ' -f2)
EOF

/bin/bash

