#!/bin/bash

set -ex

PREFIX=$1
HOST_SWITCH=$2
CROSS_NAME=$3
if [ ! -d "${PREFIX}" ]
then
	echo "Prefix directory \"$PREFIX\" does not exist"
	exit 1
fi

if [ ! -d "${HOST_SWITCH}" ]
then
	echo "Host switch directory \"$HOST_SWITCH\" does not exist"
	exit 1
fi

if [ -z "$CROSS_NAME" ]
then
	echo "A toolchain name must be specified"
	exit 1
fi

echo "-- making directories in $PREFIX"
mkdir -p $PREFIX/bin
mkdir -p $PREFIX/lib
mkdir -p $PREFIX/lib/ocaml/caml
mkdir -p $PREFIX/lib/ocaml/stublibs
mkdir -p $PREFIX/lib/stublibs

echo "-- installing compiler tooling to $PREFIX"
OCAMLRUN="$HOST_SWITCH/bin/ocamlrun" make install

echo "-- seting up ocamlfind config for host switch $HOST_SWITCH with toolchain $CROSS_NAME"
mv $HOST_SWITCH/lib/findlib.conf $HOST_SWITCH/lib/findlib.conf.bak
sed -e "/(${CROSS_NAME})/d" $HOST_SWITCH/lib/findlib.conf.bak > $HOST_SWITCH/lib/findlib.conf
cat << EOF >> $HOST_SWITCH/lib/findlib.conf
path($CROSS_NAME)="$PREFIX/lib:$PREFIX/lib/ocaml"
destdir($CROSS_NAME)="$PREFIX/lib"
stdlib($CROSS_NAME)="$PREFIX/lib/ocaml"
ocamlc($CROSS_NAME)="$PREFIX/bin/ocamlc"
ocamlopt($CROSS_NAME)="$PREFIX/bin/ocamlopt"
ocamldep($CROSS_NAME)="$PREFIX/bin/ocamldep"
ocamlmklib($CROSS_NAME)="$PREFIX/bin/ocamlmklib"
ldconf($CROSS_NAME)="$PREFIX/lib/ocaml/ld.conf"
EOF

cat << EOF > $PREFIX/lib/ocaml/ld.conf
$PREFIX/lib/ocaml/stublibs
$PREFIX/lib/ocaml
EOF
