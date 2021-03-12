reset

set multiplot layout 1,2
set datafile separator ';'
set style data lines

set title "Save Data Frame Time"
gsSaveData = 'data_gs_save.csv'
gsLoadData = 'data_gs_load.csv'

gaSaveData = 'data_ga_save.csv'
gaLoadData = 'data_ga_load.csv'

set grid y
set yrange[0:70000]
set ytics auto
set xtics auto
set ylabel "Frame Time (us)"
set xlabel "Frame"

set bmargin 5
set style fill solid 0.3

plot gsSaveData using 1 title 'Gs', gaSaveData using 1 title 'Ga'

set title "Load Data Frame Time" 
plot gsLoadData using 1 title 'Gs', gaLoadData using 1 title 'Ga'
unset multiplot