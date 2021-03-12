reset
set size 1800, 600
set multiplot layout 1,2
set datafile separator ';'

set boxwidth 1
set style data histogram
set style histogram cluster

set title "Save State Execution Time"
gsSaveData = 'data_gs_save.csv'
gsLoadData = 'data_gs_load.csv'

gaSaveData = 'data_ga_save.csv'
gaLoadData = 'data_ga_load.csv'

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

set title "Load State Execution Time" 

plot gsLoadData using 8 title 'Gs' lt rgb "black", gaLoadData using 8 title 'Ga' lt rgb "grey"

unset multiplot