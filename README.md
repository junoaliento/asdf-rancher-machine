<div align="center">

# asdf-rancher-machine [![Build](https://github.com/junoaliento/asdf-rancher-machine/actions/workflows/build.yml/badge.svg)](https://github.com/junoaliento/asdf-rancher-machine/actions/workflows/build.yml) [![Lint](https://github.com/junoaliento/asdf-rancher-machine/actions/workflows/lint.yml/badge.svg)](https://github.com/junoaliento/asdf-rancher-machine/actions/workflows/lint.yml)

[rancher-machine](https://github.com/rancher/machine) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl` and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add rancher-machine https://github.com/junoaliento/asdf-rancher-machine.git
```

rancher-machine:

```shell
# Show all installable versions
asdf list-all rancher-machine

# Install specific version
asdf install rancher-machine latest

# Set a version globally (on your ~/.tool-versions file)
asdf global rancher-machine latest

# Now rancher-machine commands are available
rancher-machine -v
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/junoaliento/asdf-rancher-machine/graphs/contributors)!

# License

This software is released under the [Apache License, Version 2.0](LICENSE).
