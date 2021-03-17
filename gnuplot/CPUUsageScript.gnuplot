reset
set size 1800, 600
set multiplot layout 1,2
set datafile separator ';'
set style data lines

set title "Save State CPU Utilization With Complexity ".(ARG1+1)
fileEnd = ARG1.".csv";
gsSaveData = "../data/gs_save_".fileEnd
gsLoadData = "../data/gs_load_".fileEnd

gaSaveData = "../data/ga_save_".fileEnd
gaLoadData = "../data/ga_load_".fileEnd

set grid y

set ytics auto nomirror
set xtics nomirror
set ylabel "CPU Utilization (%)"
set xlabel "Frame"

set bmargin 5
set style fill solid 0.3

plot gsSaveData using 3 title 'Gs', gaSaveData using 3 title 'Ga'

set title "Load State CPU Utilization With Complexity ".(ARG1+1)

plot gsLoadData using 3 title 'Gs', gaLoadData using 3 title 'Ga'

unset multiplot