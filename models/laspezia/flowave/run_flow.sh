#!/bin/bash
#$ -V
#$ -j yes

    # This script starts a single-domain Delft3D-FLOW computation on Linux in parallel mode
    # asuming nodes are allocated manually
    #
    # Usage example:
    # Create a file named machinefile as described below
    # Execute this script
    #
    # In case the error "unable to find mpd.conf" occurs:
    # Your home directory MUST contain file .mpd.conf with contents:
    # secretword=bla
    # and with file access permissions:
    # -r--------
    #

    #
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
	set NHOSTS manually here:
        export NHOSTS=8
        NPART=$NHOSTS
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
	set NHOSTS manually here:
        export NHOSTS=12
        NPART=$NHOSTS
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
	set NHOSTS manually here:
        export NHOSTS=12
        NPART=$NHOSTS
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
	set NHOSTS manually here:
        export NHOSTS=12
        NPART=$NHOSTS
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
	set NHOSTS manually here:
        export NHOSTS=12
        NPART=$NHOSTS
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
	set NHOSTS manually here:
        export NHOSTS=12
        NPART=$NHOSTS
        ;;
esac


argfile=config_d_hydro.xml
    #
    # Set the directory containing delftflow.exe
    #
    #
# Set the config file and mdw file

# Set the directories containing d_hydro, wave, swan, swan.sh here
export ARCH=lnx64
curdir=`pwd`
exedir=$D3D_HOME/$ARCH/flow2d3d/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$D3D_HOME/lib64
export PATH=$exedir:$PATH

    # No adaptions needed below
    #

    # Set some (environment) parameters
   # Run

    ### command="d3d.run -nproc "$NHOSTS" -input "$inputfile" -back no
    ### eval $command

    ### General for MPICH2, startup your MPICH2 communication network (you
    ### can check if it is already there with mpdtrace).
    ###
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
mpd &


    ### Optionally:
    ### Add option --rsh=/usr/bin/rsh to mpdboot
    ### This is needed when the following error appears:
    ### mpdboot_xh5000 (handle_mpd_output 420): from mpd on xh5001, invalid port info: no_port
mpdboot -n $NHOSTS -f $(pwd)/machinefile --ncpus=2

# link mpich debug rubbish to /dev/null
node_number=$NPART
while test $node_number -ge 1
do
   node_number=`expr $node_number - 1`
   ln -s /dev/null log$node_number.irlog
done

    ### For debug purpose:
echo " "
echo "ldd libflow2d3d.so: start"
ldd $exedir/libflow2d3d.so
echo "ldd libflow2d3d.so: end"
echo " "

    ### General, start delftflow in parallel by means of mpirun.
    ### The machines in the h4 cluster are dual core; start 2*NHOSTS parallel processes
mpirun -np $NHOSTS $exedir/d_hydro.exe $argfile
    ### alternatives:
    ### mpiexec -n $DELTAQ_NumNodes delftflow_91.exe -r $inputfile.mdf
    ### mpiexec -n `expr $DELTAQ_NumNodes \* 2` $exedir/deltares_hydro.exe $argfile


rm -f log*.irlog

    ### General for MPICH2, finish your MPICH2 communication network.
mpdallexit 

