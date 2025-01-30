#!/bin/sh
$ZIG_PATH version || (echo "Zig binary at ZIG_PATH=$ZIG_PATH not runnable" && exit 1)
echo "" > conf-ocaml-cross.config
echo "host_triple: \"${HOST_TRIPLE}\"" >> conf-ocaml-cross.config
echo "host_target: \"${HOST_TARGET}\"" >> conf-ocaml-cross.config
echo "zig_path: \"${ZIG_PATH}\"" >> conf-ocaml-cross.config
