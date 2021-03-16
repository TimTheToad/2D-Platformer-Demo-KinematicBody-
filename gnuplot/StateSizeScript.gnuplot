reset
set size 1800, 600
set multiplot layout 1,3
set datafile separator ';'
set boxwidth 0.5
set style fill solid
set boxwidth 1
set style data histogram
set style histogram cluster

gsSaveData0 = "../data/gs_save_0.csv"
gaSaveData0 = "../data/ga_save_0.csv"

gsSaveData1 = "../data/gs_save_1.csv"
gaSaveData1 = "../data/ga_save_1.csv"

gsSaveData2 = "../data/gs_save_2.csv"
gaSaveData2 = "../data/ga_save_2.csv"

set grid y
unset key

set xrange[0:3]
set xtics ("Gs" 1, "Ga" 2)
set ytics auto

set ylabel "Size (Bytes)"
set xlabel "Implementation Model"

set bmargin 5
set style fill solid 0.3

set title "State Data Complexity 1"
plot gsSaveData0 using 5 title 'Gs' lt rgb "black", gsSaveData1 using 5 title 'Gs' lt rgb "black", gsSaveData2 using 5 title 'Gs' lt rgb "black", \
    gaSaveData0 using 5 title 'Gs' lt rgb "black", gaSaveData1 using 5 title 'Gs' lt rgb "black", gaSaveData2 using 5 title 'Gs' lt rgb "black"


unset multiplot