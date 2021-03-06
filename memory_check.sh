#!/bin/bash
#This script will check the memory usage
#Emerson R. Aduna

PETSA=`date +%Y%m%d" "%H:%M`

USED_MEM=$(free | grep Mem | awk '{printf("%.0f"), $3/$2 * 100.0}')
#echo "Total free memory is $USED_MEM"

#if no parameter were supplied then show instructions
if [ $# -eq 0 ];
then
cat /home/monitor/scripts/man_memorycheck
exit 0
fi

while getopts "c:w:e:" arg; do
 case $arg in

c)
Critical=$OPTARG
;;
w)
Warning=$OPTARG
;;
e)
Email=$OPTARG
;;
#*)
#echo "Invalid input:$OPTARG" >&2
#;;
esac
done

if [ $Warning -lt $Critical ];
then

        if [ $USED_MEM -lt $Warning ];
        then
        echo "Memory Usage is now at Normal State:$USED_MEM" | mail -s "$PETSA Alert Memory Usage is at Normal State" $Email
        exit 0

        elif  [ $USED_MEM -ge $Warning -a $USED_MEM -lt $Critical  ] ;
        then
        echo "Memory Usage is now at Warning State:$USED_MEM" | mail -s "$PETSA Alert Memory Usage is now at it's Warning State" $Email
        exit 1

        elif [ $USED_MEM -ge $Critical ] ;
        then
        echo "Memory Usage is at it's Critical State:$USED_MEM"
        ( ps aux | sort -nk +4 | tail ) > /tmp/topprocess
        ( mail -s "$PETSA memory - check " $Email ) < /tmp/topprocess
        exit 2
fi

        else
echo "The value of warning threshold you have entered must be less than the critical threshold "
exit 0
fi
