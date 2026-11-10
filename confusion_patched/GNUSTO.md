# GNUSTO host-system extensions

GNUSTO names are Confusion extensions, not historical MDL facilities. They
operate on ordinary host pathnames (not MDL device/name specifications).
The current implementations target POSIX systems; on Windows, operations not
implemented by the Windows port report an unsupported-operation error.

System-call failures return an MDL false value containing the system error
message and errno, in that order. Type and arity errors use Confusion's normal
call-error mechanism.

## Environment and process context

- `<GNUSTO-GETENV "NAME">` returns the environment value as a STRING, or
  `#FALSE ()` if the variable is unset.
- `<GNUSTO-GETCWD>` returns the current working directory as a STRING.
- `<GNUSTO-CHDIR "PATH">` changes the interpreter process's working directory;
  returns `T` on success.
- `<GNUSTO-EXECUTE "PROGRAM" <VECTOR "ARG" ...>>` runs PROGRAM synchronously
  without invoking a shell. The vector contains arguments after `argv[0]`;
  the child inherits the current environment, working directory, and standard
  file descriptors. Returns the child's exit status, or `128 + signal` if it
  was terminated by a signal. Failure to start the program returns the system
  error false value.

## Filesystem

- `<GNUSTO-MKDIR "PATH" [MODE]>` creates one directory. MODE is an optional
  octal permission mask (default `0777`, subject to the process umask).
- `<GNUSTO-MAKEDIRS "PATH" [MODE]>` creates missing parent directories with
  the same MODE semantics; existing directories are accepted.
- `<GNUSTO-UNLINK "PATH">` removes a file or symbolic link.
- `<GNUSTO-SYMLINK "TARGET" "LINK">` creates a symbolic link.
- `<GNUSTO-CHMOD "PATH" MODE>` changes permission bits; MODE is an octal FIX.
- `<GNUSTO-STAT "PATH">` returns a ten-element VECTOR:
  `#[MODE SIZE UID GID ATIME MTIME CTIME DEV INO NLINK]`.
- `<GNUSTO-DIRECTORY-LIST "PATH">` returns a LIST of entry-name STRINGs,
  sorted lexicographically and excluding `.` and `..`.

Historical MDL facilities such as `RENAME`, `FILECOPY`, `OPEN`, and
`FILE-EXISTS?` retain their original names and semantics.
