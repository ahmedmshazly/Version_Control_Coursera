#!/bin/bash
# Health Monitoring Tool

# Load configuration
source health_monitor.conf

# Function to collect and print system metrics
collect_metrics() {
    LOG_OUTPUT="\n$(date): Collecting metrics...\n"

    # The METRICS is the array we identified in the configuration, and we are comparing it using regex pattern "  CPU_Usage ", the spaces are 
    # for making sure we do match a word not part of a word, @ for all.
    if [[ " ${METRICS[@]} " =~ " CPU_USAGE " ]]; then
        # we used the top command, and the sed and the awk commands should be always there in such cases 
        CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
        LOG_OUTPUT+="CPU Usage: $CPU_USAGE%\n" # Put in the log file variable
        if (( $(echo "$CPU_USAGE > $CPU_USAGE_THRESHOLD" |bc -l) )); then # bc for the mathematical float comparison
            send_alert "CPU Usage" "$CPU_USAGE%" "$CPU_USAGE_THRESHOLD%"
        fi
    fi
    
    # Same here as above
    if [[ " ${METRICS[@]} " =~ " MEMORY_USAGE " ]]; then
        MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
        LOG_OUTPUT+="Memory Usage: $MEMORY_USAGE%\n"
        if (( $(echo "$MEMORY_USAGE > $MEMORY_USAGE_THRESHOLD" |bc -l) )); then
            send_alert "Memory Usage" "$MEMORY_USAGE%" "$MEMORY_USAGE_THRESHOLD%"
        fi
    fi

    echo -e $LOG_OUTPUT >> logs/health_monitor.log
}

# Function to send alerts
send_alert() {
    METRIC=$1
    VALUE=$2
    THRESHOLD=$3
    ALERT_OUTPUT="$(date): ALERT: $METRIC threshold exceeded: Current value is $VALUE, which is above the threshold of $THRESHOLD.\n"
    echo -e $ALERT_OUTPUT >> logs/health_monitor.log
}


collect_metrics
