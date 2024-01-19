# kcu116_vnme_example Vivado


## Description

Test project for kcu116 board.

## Usage

Tcl Console in Vivado
```
cd {your_dir}/kcu116_nvme_example/vivado/
source ./nvme_example.tcl
```
Or run `test.bat`(only Windows)

## Add your files

Need modify `nvme_example.tcl` file.


<!---
`File->Project->Write Project` Remove the check mark "Copy sources to new project"
-->

### Add your block design

`Open bd->File->Export->Export Block Design`

Add the following lines of code to the end of the `nvme_example.tcl` file
```
...
## Add your block design
source ./bd/<design_name>.tcl
...
```
