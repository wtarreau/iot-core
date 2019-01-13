#!/bin/bash

# encodes stdin for binary output
od -v -An -tu1 | while read; do
    echo -n "]==]..string.char(unpack({";
    echo -n $REPLY,|tr ' ' ','
    echo "}))..[==["
done
