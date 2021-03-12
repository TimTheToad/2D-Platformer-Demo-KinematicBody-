reset
set size 1800, 600
set multiplot layout 1,4
set datafile separator ';'
set boxwidth 0.5
set style fill solid

set title "State Data"
gsSaveData = 'data_gs_save.csv'
gsLoadData = 'data_gs_load.csv'

gaSaveData = 'data_ga_save.csv'
gaLoadData = 'data_ga_load.csv'

set grid y
unset key

set xrange[0:3]
set xtics ("Gs" 1, "Ga" 2) scale 0.0
set ytics auto

set ylabel "Size (Bytes)"
set xlabel "Implementation Model"

set bmargin 5
set style fill solid 0.3

plot gsSaveData using (1):5 title 'Gs' lt rgb "black" with boxes, gaSaveData using (2):5 title 'Ga' lt rgb "grey" with boxes

unset multiplot