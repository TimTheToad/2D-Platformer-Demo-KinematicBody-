reset
set size 1800, 600
set multiplot layout 1,2
set datafile separator ';'
set boxwidth 0.5
set style fill solid
set boxwidth 1
set style data histogram
set style histogram cluster

set grid y

set xrange[0:3]
set xtics ("Gs" 1, "Ga" 2) nomirror
set ytics auto nomirror

set ylabel "Size (Bytes)"
set xlabel "Implementation Model"

set bmargin 5
set style fill solid 0.3

set title "State Data Comparison"
plot "../data/StateSizeAndNodeCount.csv" using 2 title 'Complexity 1', "" using 3 title 'Complexity 2', "" using 4 title 'Complexity 3'

set title "Node Count Comparison"
plot "../data/StateSizeAndNodeCount.csv" using 5 title 'Complexity 1', "" using 6 title 'Complexity 2', "" using 7 title 'Complexity 3'

unset multiplot