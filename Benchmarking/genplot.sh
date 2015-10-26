#!/bin/bash

if test "$#" -lt 2; then
    echo "Usage: $0 <jobid> <type> [comments]"
    exit 1
fi

ID=$1
TYPE=$2
LABEL=$3
TMP=temp

#mkdir -p results/$1
#cd results/gatling/mon
cd results
rm -f *.dat "report-$ID-$LABEL.png" *.bak $TMP
H=`grep Host dstat.*.$ID | awk -F, '{print $2}' | sed 's/"//g'`
echo "Generating Report for Job $ID and host $H"

DF="dstat.$H.$ID"
grep -Ev 'CSV|Author|Host|Cmdline|time|date|system|COMMENTS' $DF > dstat.dat
# save comments for later
echo "COMMENTS: $LABEL" >> $DF


srch() {
cat << EOF
unset datafile separator
set border linewidth 2
set title "LDAP Search Rate" tc rgb "red"
set ylabel "rate"
set y2label "latency"
set ytics nomirror
set y2range [0:10]
set y2tics
unset xtics
set yrange [0:40000]
set xdata time
plot "srch.dat" using 0:2 smooth csplines lw 1 title "srch/s" with lines, \
"srch.dat" using 0:4 smooth csplines lw 1 title "resp (ms)" axis x1y2
unset yrange

EOF
}

mod() {
cat << EOF
unset datafile separator
set border linewidth 2
set title "LDAP Mod Rate" tc rgb "red"
set ylabel "rate"
set y2label "latency"
set ytics nomirror
set y2range [0:10]
set yrange [0:2000]
set xdata time
unset xtics
plot "mod.dat" using 0:2 lw 1 title "mod/s" with lines, \
"mod.dat" using 0:4 smooth csplines lw 1 title "resp (ms)" axis x1y2

EOF
}

auth () {
cat << EOF
unset datafile separator
set border linewidth 2
set title "LDAP Auth Rate" tc rgb "red"
set ylabel "rate"
set y2label "latency"
set ytics nomirror
set y2range [0:10]
set yrange [0:60000]
set y2tics
set xdata time
unset xtics
plot "auth.dat" using 0:2 smooth csplines lw 1 title "auth/s" with lines, \
"auth.dat" using 0:4 smooth csplines lw 1 title "resp (ms)" axis x1y2

EOF
}

add() {
cat << EOF
unset datafile separator
set border linewidth 2
set title "LDAP Add Rate" tc rgb "red"
set ylabel "rate"
set y2label "latency"
set ytics nomirror
set y2tics
set y2range [0:100]
set yrange [0:1000]
set xdata time
unset xtics
plot "add.dat" using 0:2 lw 1 title "add/s" with lines, \
"add.dat" using 0:4 smooth csplines lw 1 title "resp (ms)" axis x1y2

EOF
}

comments () {
if [ -z "$LABEL" ]
then
   LABEL=`grep "COMMENTS" $DF | awk -F: '{print $1}'`
fi

cat << EOF
set title "Job Comments"
unset ylabel
unset xlabel
unset y2label
unset xtics
unset ytics
unset y2tics
set key off
unset border
set xrange [0:50]
set yrange [0:50]
set style line 1 lc rgb '#000000' lt 1 lw 1.0
set label '$LABEL' at 0,45 enhanced font 'Arial-Bold,10'
set label 'See sysinfo.xx.$ID for detailed cn=monitior matricies' at 0,40 enhanced font 'Arial-Bold,10'
plot 1 ls 1
EOF
}

common () {
cat << EOF
if (!exists("MP_LEFT"))   MP_LEFT = .1
if (!exists("MP_RIGHT"))  MP_RIGHT = .9
if (!exists("MP_BOTTOM")) MP_BOTTOM = .1
if (!exists("MP_TOP"))    MP_TOP = .9
if (!exists("MP_GAP"))    MP_GAP = 0.1

set terminal png size 1920,1080 enhanced font 'Helvetica,7'
set output "report-$ID-$LABEL.png"
#set terminal pdf enhanced color lw 3 size 3,2 font 'Arial-Bold'
#set output "report-$ID.pdf"
#set terminal postscript eps enhanced font 'Courier,6'

set multiplot layout 3,2 columnsfirst title "{/:Bold=8 Job $ID Report for host $H}" \
margins MP_LEFT, MP_RIGHT, MP_BOTTOM, MP_TOP spacing MP_GAP
#set size 1.0, 1.0
#set grid

set datafile separator ","
set xtics nomirror

#set origin 0.0,0.0
set title "CPU usage"
#set xlabel "time"
set ylabel "percent"
set xdata time
set timefmt "%d-%m %H:%M:%S"
set format x "%H:%M"
plot "dstat.dat" using 1:2 smooth csplines title "usr" with lines, \
"dstat.dat" using 1:3 smooth csplines title "sys" with lines, \
"dstat.dat" using 1:4 smooth csplines title "idl" with lines

#set origin 0.5,0.5
set title "Disk"
#set xlabel "time"
#set yrange [0:200000000]
set ylabel "read/write"
set xdata time
set timefmt "%d-%m %H:%M:%S"
set format x "%H:%M"
set format y '%.0s%c'
plot "dstat.dat" using 1:14 smooth csplines  title "read MB/s" with lines, \
"dstat.dat" using 1:15 smooth csplines title "write MB/s" with lines
unset format y

EOF
}

extra() {
cat << EOF
#set origin 0.0,0.5
set title "Memory"
#set xlabel "time"
set format y '%.0s%c'
set ylabel "size"
set xdata time
set timefmt "%d-%m %H:%M:%S"
set format x "%H:%M"
plot "dstat.dat" using 1:8 title "usr" with lines, \
"dstat.dat" using 1:9 smooth csplines title "buff" with lines, \
"dstat.dat" using 1:10 smooth csplines title "cache" with lines, \
"dstat.dat" using 1:11 smooth csplines title "free" with lines

#set origin 0.5,0.0
set title "Network"
#set xlabel "time"
set ylabel "MB/s"
set xdata time
set timefmt "%d-%m %H:%M:%S"
set format x "%H:%M"
set format y '%.0s%c'
plot "dstat.dat" using 1:12 smooth csplines  title "send" with lines, \
"dstat.dat" using 1:13 smooth csplines title "recv" with lines

EOF
}


# This is main()

common > $TMP

if [ $TYPE != "mixed" ]
then
extra >> $TMP
fi


if [ $TYPE = "srch" ] || [ $TYPE = "mixed" ]
then
grep -Ev '\-\-\-|Time|second|recent' srchrate.$H.$ID  > srch.dat
srch >> $TMP
fi

if [ $TYPE = "mod" ] || [ $TYPE = "mixed" ]
then
grep -Ev '\-\-\-|Time|second|recent' modrate.$H.$ID  > mod.dat
mod >> $TMP
fi

if [ $TYPE = "auth" ] || [ $TYPE = "mixed" ]
then
grep -Ev '\-\-\-|Time|second|recent' authrate.$H.$ID  > auth.dat
auth >> $TMP
fi

if [ $TYPE = "add" ] || [ $TYPE = "mixed" ]
then
grep -Ev '\-\-\-|Time|second|recent' addrate.$H.$ID  > add.dat
add >> $TMP
fi

if [ $TYPE = "none" ]
then
 echo ""
fi

comments >> $TMP

gnuplot -c $TMP

open "report-$ID-$LABEL.png"
