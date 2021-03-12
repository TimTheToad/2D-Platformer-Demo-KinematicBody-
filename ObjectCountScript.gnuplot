reset
set size 1800, 600
set multiplot layout 1,2
set datafile separator ';'
set style data lines

set title "Save State Objects"
gsSaveData = 'data_gs_save.csv'
gsLoadData = 'data_gs_load.csv'

gaSaveData = 'data_ga_save.csv'
gaLoadData = 'data_ga_load.csv'

set grid y

set ytics auto
set ylabel "Number of Objects"
set xlabel "Frame"

set bmargin 5
set style fill solid 0.3

plot gsSaveData using 7 title 'Gs', gaSaveData using 7 title 'Ga'

set title "Load State Objects" 

plot gsLoadData using 7 title 'Gs', gaLoadData using 7 title 'Ga'

unset multiplot