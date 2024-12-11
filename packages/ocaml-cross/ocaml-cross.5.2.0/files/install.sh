#!/bin/bash

set -e

PREFIX=$1
if [ ! -d "${PREFIX}" ]
then
	echo "Prefix directory \"$PREFIX\" does not exist"
	exit 1
fi

mkdir -p $PREFIX/bin
mkdir -p $PREFIX/lib
mkdir -p $PREFIX/lib/ocaml/caml
mkdir -p $PREFIX/lib/ocaml/stublibs
mkdir -p $PREFIX/lib/stublibs

cp ocaml $PREFIX/bin
cp ocamlc $PREFIX/bin
cp ocamlopt $PREFIX/bin
cp boot/ocamlrun $PREFIX/bin
cp tools/ocamlmklib $PREFIX/bin
cp tools/ocamldep $PREFIX/bin
cp tools/ocamlobjinfo $PREFIX/bin
cp tools/ocamlcmt $PREFIX/bin
cp tools/ocamlcp $PREFIX/bin
cp tools/ocamlmktop $PREFIX/bin
cp tools/ocamloptp $PREFIX/bin

make -C stdlib install installopt
make -C otherlibs/dynlink install installopt
make -C otherlibs/runtime_events install installopt
make -C otherlibs/str install installopt
make -C otherlibs/systhreads install installopt
make -C otherlibs/unix install installopt

cp boot/libcamlrun.a $PREFIX/lib/ocaml
cp boot/libcamlrun_shared.so $PREFIX/lib/ocaml

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
