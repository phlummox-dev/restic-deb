
# restic-deb

[restic][restic-repo], shoved into a .deb file (created
using the [alien][alien] package converter).

The .deb file contains the static binary, man pages,
and bash-completion function.

## rationale

As at the time of writing (Jan 2022), the version of restic contained in
the Ubuntu repositories is missing bugfixes and capabilities found in
recent versions of restic (e.g. the ability to use [rclone][rclone]
backends, added in restic 0.9.0 in 2018).

So this repo downloads the static binary for restic 0.12.1 from the
GitHub releases page for restic, uses it generate man pages and a bash
completion file, and shoves it all into a .deb.

[restic-repo]: https://github.com/restic/restic/ 
[alien]: https://sourceforge.net/projects/alien-pkg-convert/
[rclone]: https://github.com/rclone/rclone 

## copyright

The restic binary and everything it generates are licensed under the BSD
2-Clause "Simplified" License ([here][restic-license]).

[restic-license]: https://github.com/restic/restic/blob/master/LICENSE

Insofar as they represent anything copyrightable, the contents of this
repo are placed in the public domain.

