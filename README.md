# AstolfOS Build Bot

A Docker image that builds every updated package and creates a pacman repository on a schedule. The image is available under `ghcr.io/astolfoos/buildbot:latest`

## Volumes

| Path               | Usage                                          |
| ------------------ | ---------------------------------------------- |
| /buildbot/packages | Where the source PKGBUILD repository is stored |
| /buildbot/repo     | Where the generated repo is stored             |
| /buildbot/tmp      | Where the build files are copied for building  |

## Environment Variables

| Variable  | Default                                   | Usage                                                                                    |
| --------- | ----------------------------------------- | ---------------------------------------------------------------------------------------- |
| REPO_URL  | https://github.com/AstolfoOS/packages.git | The URL of the source repository. Must contain directories which each contain a PKGBUILD |
| REPO_NAME | astolfos                                  | The name of the generated repo                                                           |

## License

Everything in this repo is licensed under the GPL3 (or any later version)
