#!/bin/bash
## FindIdealBlockSize.bash
## A script goes through a range of block sizes to se how they effect the perfoirmance of the drive
## Tom Fenton
## Ver 1 Thu 04 Feb 2021 11:58:44 PM UTC
## Stuff lect to do
## Colorize output
## get better fio tests
## make the disk a variable and all the vars passable to the script
##
##
## Shell subroutine to echo to screen and a log file
##
today=`date '+%Y_%m_%d__%H_%M_%S'`
FinalOutFile="./$today.VariableBS_TestRun.out"
OutFile="./last.VariablesBS.out"
echo "This Program will write ouput to $OutFile "
echo "This Program will write ouput to $FinalOutFile "
##
##
echolog()
(
    echo "$@"
    echo "$@" >> $OutFile
)
##
echo "Program started at $today" > $OutFile  ## to start a fresh file as echolog will append
echolog "Program started at $today"
## Vars
FioRunTime=300 #Time in seconds to run the fio jobs
echolog "MSG FioRunTime is $FioRunTime"
FioNumJobs=2
echolog "MSG FioNumJobs is $FioNumJobs"
##

for MySize in 4 16 64 128 512 1024 2048
do
        echo "$MySize blcoksize test"
        echolog "MSG Perfoamance Info - fio $MySize rand write test"
        fio --filename=/dev/sdb --ioengine=libaio --rw=randwrite --bs=${MySize}k --numjobs=1 --size=4g --iodepth=32 --runtime=$FioRunTime --time_based --end_fsync=1 --name=${MySize}K_randwrite  >> $OutFile

        echolog "MSG Perfoamance Info - fio $mysize 80/20  test"
        fio --filename=/dev/sdb --ioengine=libaio --rw=randrw --rwmixread=80 --bs=${MySize}k --numjobs=1 --size=4g --iodepth=32 --runtime=$FioRunTime --time_based --end_fsync=1 --name=${MySize}k_randRW  >> $OutFile
done

EndTime=`date '+%Y_%m_%d__%H_%M_%S'`;
echolog "Job Finished at $EndTime"

$OutFile $FinalOutFile
grep 'MSG\|iops\|read\|write' $OutFile
