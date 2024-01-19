# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Users\vyurchenko\Documents\workspace_vitis\nvme_example\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Users\vyurchenko\Documents\workspace_vitis\nvme_example\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {nvme_example}\
-hw {../vivado/nvme_example/nvme_wrapper.xsa}\
-proc {microblaze_0} -os {standalone} -out {./}

platform write
platform generate -domains 
platform active {nvme_example}
platform generate
bsp reload
