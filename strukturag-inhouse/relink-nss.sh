#!/bin/bash -x 


# This script properly relinks nss to our inhouse nss implementation


function relink_nss()
{
	echo "Relink nss and subsequently sqlite"
	mv ../chromium/src/third_party/nss ../chromium/src/third_party/nss_disabled_chromium
	ln -s ../../../strukturag-inhouse/inhouse-deps/nss ../chromium/src/third_party/nss
	rm inhouse-deps/sqlite
	ln -s ../../third_party/sqlite inhouse-deps/sqlite
}


function undo_relink_nss()
{
	echo "Undo relink nss"
	if [ -L ../chromium/src/third_party/nss ] ; then
   		rm ../chromium/src/third_party/nss 
	fi
	mv ../chromium/src/third_party/nss_disabled_chromium ../chromium/src/third_party/nss
}

if [ $# -eq 0 ] ; then
    echo "No arguments. Doing nothing."
else 
	$@
fi