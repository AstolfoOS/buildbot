# AstolfOS Build Bot

A Docker image that builds every updated package and creates a pacman repository on a schedule. The image is available under `ghcr.io/astolfoos/buildbot:latest`

Packages are built once every hour, ISOs are built once every month

To build an ISO, the container needs to be privileged (add `--privileged` to `docker run`, or add `privileged: true` to `docker-compose.yml`)

## Volumes

| Path               | Usage                                                                            |
| ------------------ | -------------------------------------------------------------------------------- |
| /buildbot/packages | Where the source PKGBUILD repository is stored                                   |
| /buildbot/repo     | Where the generated repo is stored                                               |
| /buildbot/tmp      | Where the build files are copied for building                                    |
| /buildbot/iso-src  | Where the ISO source repository is stored                                        |
| /builbot/iso       | Where the built ISOs are stored                                                  |
| /buildbot/key.asc  | The GPG secret key used to sign packages if enabled. Must not have a passphrase. |

## Environment Variables

| Variable   | Default                                   | Usage                                                                                                    |
| ---------- | ----------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| REPO_URL   | https://github.com/AstolfoOS/packages.git | The URL of the source repository. Must contain directories which each contain a PKGBUILD                 |
| REPO_NAME  | astolfos                                  | The name of the generated repo                                                                           |
| ISO_URL    | https://github.com/AstolfoOS/iso.git      | The URL of the ISO source repository                                                                     |
| ISO_WEB    | https://astolfo.laurinneff.ch/iso         | The URL where the ISO directory is available via HTTP. Used to generate the webseed URL for the torrent. |
| SIGN       | false                                     | Whether the repo, packages, and ISOs should be signed                                                    |
| DEBUG      | false                                     | If true, enables the bash xtrace option (logging every command execution)                                |
| BUILD_REPO | true                                      | If true, builds the repo                                                                                 |
| BUILD_ISO  | true                                      | If true, builds the ISO                                                                                  |

## License

Everything in this repo is licensed under the GPL3 (or any later version)
