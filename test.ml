  let x = Format.printf "My pid is %d\n" (Unix.getpid ())

let _ =
  Printf.printf "allow_unaligned_access = %b\n" Arch.allow_unaligned_access;
  Printf.printf "win64 = %b\n" Arch.aarch64
