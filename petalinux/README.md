# kcu116_nvme_example Petalinux

## Description

Script to build the petalinux project. Also here is the kernel configuration for microblaze cpu with pcie and nvme support.

## Usage

```bash
cd <your_dir>/kcu116_nvme_example/petalinux
./build.sh help

./build.sh init
./build.sh COPYCONFIG
./build.sh build
```
The script requires a `.xsa` file `../nvme_example.xsa` or in the directory `../vivado/$vivado_pdir/`
