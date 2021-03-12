reset
set size 1800, 600
set multiplot layout 1,2
set datafile separator ';'
set style data lines

set title "Save State RAM Utilization"
gsSaveData = 'data_gs_save.csv'
gsLoadData = 'data_gs_load.csv'

gaSaveData = 'data_ga_save.csv'
gaLoadData = 'data_ga_load.csv'

set grid y

set ytics auto
set ylabel "RAM Utilization (Bytes)"
set xlabel "Frame"
set key outside
set bmargin 5
set style fill solid 0.3

plot gsSaveData using 4 title 'Gs', gaSaveData using 4 title 'Ga'

set title "Load State RAM Utilization" 

plot gsLoadData using 4 title 'Gs', gaLoadData using 4 title 'Ga'

unset multiplot