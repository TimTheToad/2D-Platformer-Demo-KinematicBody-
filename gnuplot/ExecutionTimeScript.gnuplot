reset
set size 1800, 600
set multiplot layout 1,2
set datafile separator ';'

set boxwidth 1
set style data histogram
set style histogram cluster

set title "Save State Execution Time With Complexity ".(ARG1+1)
fileEnd = ARG1.".csv";
gsSaveData = "../data/gs_save_".fileEnd
gsLoadData = "../data/gs_load_".fileEnd

gaSaveData = "../data/ga_save_".fileEnd
gaLoadData = "../data/ga_load_".fileEnd

set grid y
set key outside
set xrange[0:11]
set ytics auto
set xtics 1
set ylabel "Execution Time (µs)"
set xlabel "Sample"

set bmargin 5
set style fill solid 0.3

plot gsSaveData using 8 title 'Gs' lt rgb "black", gaSaveData using 8 title 'Ga' lt rgb "grey"

set title "Load State Execution Time With Complexity ".(ARG1+1)

plot gsLoadData using 8 title 'Gs' lt rgb "black", gaLoadData using 8 title 'Ga' lt rgb "grey"

unset multiplot