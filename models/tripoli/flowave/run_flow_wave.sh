#!/bin/bash
    # Known bug:
    # See http://oss.deltares.nl/web/delft3d/release-notes#3058
    #
    # This script starts a single-domain Delft3D-FLOW(6.00) computation (Linux) in parallel mode,
    # running online with a Delft3D-WAVE
    #
    # !!!!! IMPORTANT !!!!!
    # When using mpich2 for the first time:
    # In case the error "unable to find mpd.conf" occurs:
    # Your home directory MUST contain file .mpd.conf with contents:
    # secretword=bla
    # and with file access permissions:
    # -r--------
    #
    # adri.mourits@deltares.nl
    # menno.genseberger@deltares.nl
    # 29 Oct 2013 

echo "   Working on "$HOSTNAME
case $HOSTNAME in
    todd)
        ulimit -s unlimited
        #===============================================================
        # Exporting path for intel compilers
        export PATH=$PATH:/opt/intel/bin/
        export LD_LIBRARY_PATH=:/opt/intel/lib/intel64/
        #===============================================================
        # Exporting path for mpich
        export PATH=/opt/mpich-3.2.1/bin/:${PATH}
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/mpich-3.2.1/lib64/
        #===============================================================
        # Exporting path for netcdff
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.5.3_ifort/lib64/
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.7.4_icc/lib64/
        #===============================================================
        export D3D_HOME=/opt/Delft3D/tag_7545_build
        export NHOSTS=1
        export processes_per_node=8
        ;;	
    bart)
	ulimit -s unlimited
	#===============================================================
	# Exporting path for intel compilers
	export PATH=$PATH:/opt/intel/bin/
	export LD_LIBRARY_PATH=:/opt/intel/lib/intel64/
	#===============================================================
	# Exporting path for mpich
	export PATH=/opt/mpich3.2/bin/:${PATH}
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/mpich3.2/lib64/
	#===============================================================
	# Exporting path for netcdff
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.4.4_ifort/lib64/
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.5.0_icc/lib64/
	#===============================================================
	export D3D_HOME=/opt/src/Delft3D/7545/bin
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/src/Delft3D/7545/src/lib64/
	export NHOSTS=1
	export processes_per_node=10
	;;
    boe)
	ulimit -s unlimited
	#===============================================================
	# Exporting path for intel compilers
	export PATH=$PATH:/opt/intel/bin/
	export LD_LIBRARY_PATH=:/opt/intel/lib/intel64/
	#===============================================================
	# Exporting path for mpich
	export PATH=$PATH:/opt/mpich3.3.1/bin/
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/mpich3.3.1/lib64/
	#===============================================================
	# Exporting path for netcdff
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.5.2_ifort/lib64/
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.7.1_icc/lib64/
	#===============================================================
	export D3D_HOME=/opt/Delft3D/tag_7545_build
	export NHOSTS=1
	export processes_per_node=10
	;;
    lisa)
	ulimit -s unlimited
	#===============================================================
	# Exporting path for intel compilers
	export PATH=$PATH:/opt/intel/bin/
	export LD_LIBRARY_PATH=:/opt/intel/lib/intel64/
	#===============================================================
	# Exporting path for mpich
	export PATH=/opt/mpich3.2/bin/:${PATH}
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/mpich3.2/lib64/
	#===============================================================
	# Exporting path for netcdff
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.4.4_ifort/lib64/
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.5.0_icc/lib64/
	#===============================================================
	export D3D_HOME=/opt/src/Delft3D/7545/bin
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/src/Delft3D/7545/src/lib64/
	export NHOSTS=1
	export processes_per_node=10
	;;
    ned)
	ulimit -s unlimited
	#===============================================================
	# Exporting path for intel compilers
	export PATH=$PATH:/opt/intel/bin/
	export LD_LIBRARY_PATH=:/opt/intel/lib/intel64/
	#===============================================================
	# Exporting path for mpich
	export PATH=/opt/mpich-3.2.1/bin/:${PATH}
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/mpich-3.2.1/lib64/
	#===============================================================
	# Exporting path for netcdff
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.5.3_ifort/lib64/
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.7.4_icc/lib64/
	#===============================================================
	export D3D_HOME=/opt/Delft3D/tag_7545_build
	export NHOSTS=1
	export processes_per_node=10
	;;
    willie)
	ulimit -s unlimited
	#===============================================================
	# Exporting path for intel compilers
	export PATH=$PATH:/opt/intel/bin/
	export LD_LIBRARY_PATH=:/opt/intel/lib/intel64/
	#===============================================================
	# Exporting path for mpich
	export PATH=/opt/mpich3.2.1/bin/:${PATH}
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/mpich3.2.1/lib64/
	#===============================================================
	# Exporting path for netcdff
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.5.3_ifort/lib64/
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/netcdf_4.7.4_icc/lib64/
	#===============================================================
	export D3D_HOME=/opt/Delft3D/tag_7545_intel
	export NHOSTS=1
	export processes_per_node=10
	;;
esac

# Set the config file and mdw file
argfile=config_d_hydro.xml
mdwfile=tripoli.mdw

# Set the directories containing d_hydro, wave, swan, swan.sh here
export ARCH=lnx64
curdir=`pwd`
flowexedir=$D3D_HOME/$ARCH/flow2d3d/bin
waveexedir=$D3D_HOME/$ARCH/wave/bin
swanexedir=$D3D_HOME/$ARCH/swan/bin
swanbatdir=$D3D_HOME/$ARCH/swan/scripts 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$D3D_HOME/lib64
export PATH=$flowexedir:$swanbatdir:$swanexedir:$waveexedir:$PATH

# Set some (environment) parameters
# Use the same mpich2 version, as used during the compilation
export NSLOTS=`expr $NHOSTS \* $processes_per_node`

echo Contents of machinefile:
cat $(pwd)/machinefile
echo ----------------------------------------------------------------------

# Start mpich2

### The use of hydra instead of mpd is adviced. hydra is the default for mpich2 version 1.4.1
### From the README:
### hydra
### -----
### Hydra is the default process management framework that uses existing 
### daemons on nodes (e.g., ssh, pbs, slurm, sge) to start MPI processes. 
### More information on Hydra can be found at 
### http://wiki.mcs.anl.gov/mpich2/index.php/Using_the_Hydra_Process_Manager
### 
### mpd
### ---
### MPD was the traditional process manager in MPICH2. The file 
### mpich2-1.4.1/src/pm/mpd/README has more information about interactive commands 
### for managing the ring of MPDs. The MPD process manager is now deprecated.
# Deltares cluster: mpd is already started
mpd &

# mpdboot: optional: --ncpus=$processes_per_node (adapted machinefile needed)
mpdboot -n $NHOSTS -f $(pwd)/machinefile --rsh=/usr/bin/rsh

# link mpich debug rubbish to /dev/null
node_number=$NSLOTS
while [ $node_number -ge 1 ]; do
   node_number=`expr $node_number - 1`
   ln -s /dev/null log$node_number.irlog
done

# Start FLOW
mpirun -np $NSLOTS $flowexedir/d_hydro.exe $argfile &

# Start WAVE
$waveexedir/wave.exe $mdwfile 1

# Clean up, finish MPICH2 network
rm -f log*.irlog
mpdallexit 

