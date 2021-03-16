reset

set multiplot layout 1,2
set datafile separator ';'
set style data lines

set title "Save Data Frame Time With Complexity ".(ARG1+1)
fileEnd = ARG1.".csv";
gsSaveData = "../data/gs_save_".fileEnd
gsLoadData = "../data/gs_load_".fileEnd

gaSaveData = "../data/ga_save_".fileEnd
gaLoadData = "../data/ga_load_".fileEnd

set grid y
set yrange[0:70000]
set ytics auto
set xtics auto
set ylabel "Frame Time (µs)"
set xlabel "Frame"

set bmargin 5
set style fill solid 0.3

plot gsSaveData using 1 title 'Gs', gaSaveData using 1 title 'Ga'

set title "Load Data Frame Time With Complexity ".(ARG1+1) 
plot gsLoadData using 1 title 'Gs', gaLoadData using 1 title 'Ga'
unset multiplot