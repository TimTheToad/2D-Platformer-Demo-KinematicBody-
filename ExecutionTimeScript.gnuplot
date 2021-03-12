reset
set size 1800, 600
set multiplot layout 1,4
set datafile separator ';'
set style data lines

set title "Save Data Execution Time (Gs)"
gsSaveData = 'data_gs_save.csv'
gsLoadData = 'data_gs_load.csv'

gaSaveData = 'data_ga_save.csv'
gaLoadData = 'data_ga_load.csv'

set grid y
set yrange[0:70000]
set ytics auto
set xtics auto
set ylabel "Execution Time (us)"
set xlabel "Frame"

set bmargin 5
set style fill solid 0.3

plot gsSaveData using 2 title 'Gs' lt rgb "blue"

set title "Save Data Execution Time (Ga)" 
plot gaSaveData using 2 title 'Ga'

set title "Load Data Execution Time (Gs)" 
plot gsLoadData using 2 title 'Gs' lt rgb "blue"

set title "Load Data Execution Time (Ga)" 
plot gaLoadData using 2 title 'Ga'
unset multiplot