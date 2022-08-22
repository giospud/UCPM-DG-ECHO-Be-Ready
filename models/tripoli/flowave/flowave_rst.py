#!/opt/anaconda3/bin/python
import datetime
from datetime import timedelta 
import os
#import netCDF4
from dateutil.relativedelta import relativedelta
from sys import exit
import time

#=====================================================================

## set root folders ##

scenari="../timeseries"
scenari_RST="../timeseries_rst"
dir_log="./logs/"
dir_d3d="./"
machine = os.uname()[1]


print("  ")
print("  ")
print("=========================================================================")
print("  ")
print("  Hydrodynamic simulation of Tripoli _ on "+machine)
print("  ")
print("=========================================================================")
print("  ")

######################################################################
### Setting of the model
######################################################################


Delt=60              #restart interval[min]
Delt0=720            #warmup time[min]
SC=[9]               #scenario number
eddyvis=0.1          #eddy viscosity
Dt=0.1               #time step [min]
Flmap=10             #interval store for map file 
Flhis=0              #interval store for his file
Flpp=10              #interval store for com file
Tstart=Delt0         #start time of simulation 
Tstart0=0            #start time of simulation for warm up 
Tstop=Tstart+Delt    #stop time of simultion
Tstop0=Delt0         #stop time of simulation for warm up
Flrst=Delt           #interval store for restart file
Flrst0=Delt0         #interval store for resatrt file of the warmup
nod=7                #number of simulation days
Dur=((nod*24)-1)*60  #simulation duration[min]



for k in SC:
    print(k)

    #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    print(" Building timeseires ")
    os.system("cp "+scenari + "/timeseries_"+"%03d" % (k,)+".bct" " ./timeseries_org.bct")
    os.system("cp "+scenari + "/wave_"+"%03d" % (k,)+".bnd" " ./wave_org.bnd")
    os.system("cp "+scenari + "/wind_"+"%03d" % (k,)+".wnd" " ./wind_org.wnd")
   #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    os.system("cp tripoli.mdf_Uniformini tripoli.mdf_tmp")
    os.system("cp bndgen_tmp.m bndgen.m")
    os.system("cat bndgen_tmp.m | sed -i "+ "'s/Delt0=/Delt0="+str(Delt0)+"/"+"g'" + " bndgen.m")
    os.system("cat bndgen_tmp.m | sed -i "+ "'s/Delt=/Delt="+str(Delt)+"/"+"g'" + " bndgen.m")
    os.system("cat bndgen_tmp.m | sed -i "+ "'s/sc=/sc="+str(k)+"/"+"g'" + " bndgen.m")
    os.system("matlab -nosplash -nodesktop -nodisplay < bndgen.m > " + dir_log + "log_boundaries.txt"+ " 2>&1")


    for i in range(int(Dur/Delt)+1):
  	
        os.system("cp "+scenari_RST +"/"+"%03d" % (k)+ "/timeseries.bct_"+"%05d" % (i,)+ " ./timeseries.bct") 
        os.system("cp "+scenari_RST +"/"+"%03d" % (k)+ "/wind.wnd_"+"%05d" % (i,)+ " ./wind.wnd")
        os.system("cp "+scenari_RST +"/"+"%03d" % (k)+ "/wave.bnd_"+"%05d" % (i,)+ " ./wave.bnd")


        os.system("cp tripoli.mdf_tmp tripoli.mdf")
        os.system( "cat tripoli.mdf_tmp | sed -i  "+ "'s/Dt     =/Dt     =  "+str(Dt)+"/"+"g'" + " tripoli.mdf")
        os.system( "cat tripoli.mdf_tmp | sed -i  "+ "'s/Tstart =/Tstart =  "+str("{:.8e}".format(Tstart0))+"/"+"g'" + " tripoli.mdf")
        os.system( "cat tripoli.mdf_tmp | sed -i  "+ "'s/Tstop  =/Tstop  =  "+str("{:.8e}".format(Tstop0))+"/"+"g'" + " tripoli.mdf")
        os.system( "cat tripoli.mdf_tmp | sed -i  "+ "'s/Flmap  =/Flmap  =  "+str("{:.8e}".format(Tstart0))+" "+str(Flmap)+"  "+str("{:.8e}".format(Tstop0))+"/"+"g'" + " tripoli.mdf")
        os.system( "cat tripoli.mdf_tmp | sed -i  "+ "'s/Flhis  =/Flhis  =  "+str("{:.8e}".format(Tstart0))+" "+str(Flhis)+"  "+str("{:.8e}".format(Tstop0))+"/"+"g'" + " tripoli.mdf")
        os.system( "cat tripoli.mdf_tmp | sed -i  "+ "'s/Flpp   =/Flpp   =  "+str("{:.8e}".format(Tstart0))+" "+str(Flpp)+"  "+str("{:.8e}".format(Tstop0))+"/"+"g'" + " tripoli.mdf")
        os.system( "cat tripoli.mdf_tmp | sed -i  "+ "'s/Flrst  =/Flrst  =  "+str("{:.1e}".format(Flrst0))+"/"+"g'" + " tripoli.mdf")
        os.system( "cat tripoli.mdf_tmp | sed -i  "+ "'s/Vicouv =/Vicouv =  "+str("{:.7e}".format(eddyvis))+"/"+"g'" + " tripoli.mdf")
        

        print(" Running coupled FLOW_WAVE")
        os.system("rm tri-diag.tripoli-* com-tripoli-* TMP* td* *irlog* *url* *ddb *DATA*")
        os.system("rm wavm* trim* tri-diag.tripoli-* com-tripoli-*")
        os.system("./run_flow_wave.sh > " + dir_log + "log_d3d.txt"+ " 2>&1")
       # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
       
        a="%03d" % (k,)
        os.system("mkdir -p output/"+a)
        os.system("mv trim* tri-diag* ./output/"+a+"/")
        os.system("rm trih* wavm* com* TMP* *irlog* *url* *ddb")
        os.system("rm BOTNOW CURNOW INPUT NEST* *.ddb *.url* swaninit swan.inp WNDNOW SWANIN* TMP*")

        os.system("mv output/"+a+"/trim-tripoli.dat " "output_tripoli/"+a+"/trim-tripoli_"+"%03d" % (k,)+"_""%05d" % (i)+".dat")
        os.system("mv output/"+a+"/trim-tripoli.def " "output_tripoli/"+a+"/trim-tripoli_"+"%03d" % (k,)+"_""%05d" % (i)+".def")

        os.system("mv "+"tri-rst.tripoli*"+" tri-rst."+"%05d" % (i))
        os.system("cp tripoli.mdf_Restartini tripoli.mdf_tmp")
        os.system( "cat tripoli.mdf_tmp | sed -i  "+ "'s/Restid =/Restid = "+"#"+"%05d" % (i)+"#"+"/"+"g'" + " tripoli.mdf_tmp")
        Flrst0=Flrst
        Delt0=Delt
        Tstart0 =Tstop0
        Tstop0  =Tstop0+Delt
        print ("Done!")
        print (str(Tstart0))
        print (str(Tstop0))
        
