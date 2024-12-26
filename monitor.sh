

#getting cpu avg, 1min, 5min, 15min for now 15 is removed
top -o cpu -n 2 | grep --line-buffered -E "Load Avg|CPU usage" |
    while read -r line;
    do
        if [[ "$line" == *"Load Avg"* ]]; then
            load_avg_1_5=$(echo "$line" | sed -E 's/.*Load Avg: ([0-9.]+), ([0-9.]+), ([0-9.]+).*/\1 \2/')
            #echo "$load_avg_1_5"
            read avg1 avg5 <<< "$load_avg_1_5"
            total_avg=$(bc -l <<< "($avg1 + $avg5)/2")
            #echo "$total_avg"
            if [ "$(echo "$total_avg > 2.1" | bc -l)" ] ; then
                echo "system load is greater than 2.1%, it currently is: $total_avg"
            fi
        elif [[ "$line" == *"CPU usage"* ]]; then
            cpu_usage_user_sys=$(echo "$line" | sed -E 's/.*CPU usage: ([0-9.]+)% user, ([0-9.]+)% sys.*/\1 \2/')
            read user_cpu sys_cpu <<< "$cpu_usage_user_sys"

            echo "CPU usage - User: $user_cpu%, System: $sys_cpu%"
            if (( $(echo "$user_cpu > 10" | bc -l) )) || (( $(echo "$sys_cpu > 10" | bc -l) )); then
                echo "ALERT: High CPU usage detected! User: $user_cpu%, System: $sys_cpu%"
            fi
        fi
        sleep 3;
    done