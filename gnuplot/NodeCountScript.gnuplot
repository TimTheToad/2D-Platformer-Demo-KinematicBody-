reset
set size 1800, 600
set multiplot layout 1,2
set datafile separator ';'
set style data lines

fileEnd = ARG1.".csv";
gsSaveData = "../data/gs_save_".fileEnd
gsLoadData = "../data/gs_load_".fileEnd

gaSaveData = "../data/ga_save_".fileEnd
gaLoadData = "../data/ga_load_".fileEnd

set grid y


set ylabel "Number of Objects"
set xlabel "Frame"

set bmargin 5
set style fill solid 0.3

set title "Save State Objects With Complexity ".(ARG1+1)
set offsets graph 0, 0, 0.05, 0.05
set ytics 1
plot gsSaveData using 6 title 'Gs', gaSaveData using 6 title 'Ga'

set title "Load State Objects With Complexity ".(ARG1+1) 
unset offsets
set ytics auto
plot gsLoadData using 6 title 'Gs', gaLoadData using 6 title 'Ga'

unset multiplot