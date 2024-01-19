
proc readfile {filename} {
	set f [open $filename]
	set data [read $f]
	close $f
	return $data
}

#platform remove nvme_example
#app remove pcie_scan
#sysproj remove pcie_scan_system

# build platform
source platform.tcl
platform active nvme_example
platform generate 

# create application
app create -name pcie_scan\
	-platform nvme_example\
	-domain standalone_domain\
	-proc microblaze_0\
	-os standalone\
	-template {Empty Application}

importsource -name pcie_scan -path ./src

app build pcie_scan
#puts [readfile ./pcie_scan/Debug/pcie_scan.elf.size]

