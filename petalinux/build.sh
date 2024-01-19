projn=nvme_example
cpu_type=microblaze


vivado_pdir=../vivado/$projn
xsa_default=../nvme_example.xsa
xsa_file=(`find $vivado_pdir -name "*.xsa"`)


if [[ $1 = "help" ]]; then
	echo "\
init		create project
build		build project
package		create /images/linux/DOWNLOAD.BIT
COPYCONFIG	copy config from src directory

Build kernel only:
$ petalinux-build -c kernel

Compile kernel forcefully:
$ petalinux-build -c kernel -x compile -f
Deploy kernel forcefully:
$ petalinux-build -c kernel -x deploy -f

Build kernel and update the bootable images:
$ petalinux-build -c kernel
$ petalinux-build -x package
"
	exit 0
fi

if [[ $1 = "init" ]]; then
	shift

	if [ -d "./$projn" ]; then
		echo "[INFO] Project $projn has already been created"
	else
		petalinux-create --type project --template $cpu_type --name $projn
	fi
	
	if [ -n $xsa_file ]; then
		echo "[INFO] find" $xsa_file
		petalinux-config -p $projn --get-hw-description=$xsa_file --silentconfig
	else
		echo "[WARNING] New .xsa file not fount. Use default" $xsa_default
		if [ -f $xsa_default ]; then
			petalinux-config -p $projn --get-hw-description=$xsa_default --silentconfig
		else
			echo "[ERROR]" $xsa_default "file not fount"
			exit 1
		fi
	fi
fi

if [[ $1 = "package" ]]; then
	echo "petalinux-package -p $projn --boot --force --fpga ./$projn/images/linux/system.bit --u-boot --kernel --flash-size 256 --flash-intf SPIx4"
	petalinux-package -p $projn --boot --force --fpga ./$projn/images/linux/system.bit --u-boot --kernel --flash-size 256 --flash-intf SPIx4
	exit 0
fi

# Configuration

if [[ $1 = "COPYCONFIG" ]]; then
	cp -r ./src/project-spec/* ./$projn/project-spec/
	exit 0
fi

# Build

if [[ $1 = "build" ]]; then
	if [ -d ./$projn/images ]; then
		echo "[INFO] Project already build"
	else
		echo "[INFO] Building the $projn project"
		petalinux-build -p $projn
	fi
	echo "[INFO] Use the command \"petalinux-build -p $projn --help\""
fi

