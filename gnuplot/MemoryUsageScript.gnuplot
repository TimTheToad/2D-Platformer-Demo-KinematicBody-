reset
set size 1800, 600
set multiplot layout 1,2
set datafile separator ';'
set style data lines

set title "Save State RAM Utilization With Complexity ".(ARG1+1)
fileEnd = ARG1.".csv";
gsSaveData = "../data/gs_save_".fileEnd
gsLoadData = "../data/gs_load_".fileEnd

gaSaveData = "../data/ga_save_".fileEnd
gaLoadData = "../data/ga_load_".fileEnd

set grid y

set ytics auto nomirror
set xtics nomirror
set ylabel "RAM Utilization (KB)"
set xlabel "Frame"
set key outside
set bmargin 5
set style fill solid 0.3

plot gsSaveData using ($4/1000.0) title 'Gs', gaSaveData using ($4/1000.0) title 'Ga'

set title "Load State RAM Utilization With Complexity ".(ARG1+1)

plot gsLoadData using ($4/1000.0) title 'Gs', gaLoadData using ($4/1000.0) title 'Ga'

unset multiplot