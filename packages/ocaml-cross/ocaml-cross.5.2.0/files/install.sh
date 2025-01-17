#!/bin/bash

set -ex

PREFIX=$1
HOST_SWITCH=$2
if [ ! -d "${PREFIX}" ]
then
	echo "Prefix directory \"$PREFIX\" does not exist"
	exit 1
fi

echo "-- making directories in $PREFIX"
mkdir -p $PREFIX/bin
mkdir -p $PREFIX/lib
mkdir -p $PREFIX/lib/ocaml/caml
mkdir -p $PREFIX/lib/ocaml/stublibs
mkdir -p $PREFIX/lib/stublibs

echo "-- copying compiler tooling to $PREFIX"
OCAMLRUN="$HOST_SWITCH/bin/ocamlrun" make install

cat << EOF > $PREFIX/lib/findlib.conf
destdir="$PREFIX/lib"
path="$PREFIX/lib:$PREFIX/lib/ocaml"
ocamlc="ocamlc"
ocamlopt="ocamlopt"
ocamldep="ocamldep"
ocamldoc="ocamldoc"
stdlib="$PREFIX/lib/ocaml"
ldconf="$PREFIX/ld.conf"
EOF

cat << EOF > $PREFIX/lib/ocaml/ld.conf
$PREFIX/lib/ocaml/stublibs
$PREFIX/lib/ocaml
EOF
