reset
set size 1800, 600
set multiplot layout 2,2
set datafile separator ';'

set boxwidth 1
set style data histogram
set style histogram cluster

gsSaveData0 = "../data/gs_save_0.csv"
gsLoadData0 = "../data/gs_load_0.csv"
gaSaveData0 = "../data/ga_save_0.csv"
gaLoadData0 = "../data/ga_load_0.csv"

gsSaveData1 = "../data/gs_save_1.csv"
gsLoadData1 = "../data/gs_load_1.csv"
gaSaveData1 = "../data/ga_save_1.csv"
gaLoadData1 = "../data/ga_load_1.csv"

gsSaveData2 = "../data/gs_save_2.csv"
gsLoadData2 = "../data/gs_load_2.csv"
gaSaveData2 = "../data/ga_save_2.csv"
gaLoadData2 = "../data/ga_load_2.csv"

set grid y
set key outside
set xrange[0:11]
set xtics 1 nomirror
set ytics nomirror
set ylabel "Execution Time (ms)"
set xlabel "Sample"
set key title "Complexity"

set bmargin 5
set style fill solid

set title "Save State Execution Time Gs"
plot gsSaveData0 using ($8/1000.0) title '1' lt rgb "black", gsSaveData1 using ($8/1000.0) title '2' lt rgb "orange", gsSaveData2 using ($8/1000.0) title '3' lt rgb "purple"

set title "Save State Execution Time Ga"
plot gaSaveData0 using ($8/1000.0) title '1' lt rgb "black", gaSaveData1 using ($8/1000.0) title '2' lt rgb "orange", gaSaveData2 using ($8/1000.0) title '3' lt rgb "purple"

set title "Load State Execution Time Gs"
plot gsLoadData0 using ($8/1000.0) title '1' lt rgb "black", gsLoadData1 using ($8/1000.0) title '2' lt rgb "orange", gsLoadData2 using ($8/1000.0) title '3' lt rgb "purple"

set yrange[0:50]
set title "Load State Execution Time Ga"
plot gaLoadData0 using ($8/1000.0) title '1' lt rgb "black", gaLoadData1 using ($8/1000.0) title '2' lt rgb "orange", gaLoadData2 using ($8/1000.0) title '3' lt rgb "purple"

unset multiplot