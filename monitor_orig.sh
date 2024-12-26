

#getting cpu avg, 1min, 5min, 15min for now 15 is removed
top -o cpu -n 2 | grep --line-buffered "Load Avg|CPU usage" |
    while read -r line;
    do
        load_avg_1_5=$(echo "$line" | sed -E 's/.*Load Avg: ([0-9.]+), ([0-9.]+), ([0-9.]+).*/\1 \2/')
        #echo "$load_avg_1_5"
        read avg1 avg5 <<< "$load_avg_1_5"
        total_avg=$(bc -l <<< "($avg1 + $avg5)/2")
        #echo "$total_avg"
        if [ "$(echo "$total_avg > 2" | bc -l)" ] ; then
            echo "system load is greater than 2.1%, it currently is: $total_avg"
        fi
        sleep 3;
    done
