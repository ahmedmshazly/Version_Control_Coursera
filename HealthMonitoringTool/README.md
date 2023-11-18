# Health Monitoring Tool

This is a Bash script that monitors system health.

## Configuration

You can configure the script by editing the `health_monitor.conf` file. Here are the configuration options:

- `METRICS`: An array of the metrics to be collected. Possible values are `CPU_USAGE` and `MEMORY_USAGE`.
- `FREQUENCY`: The frequency (in seconds) at which the metrics are collected.
- `CPU_USAGE_THRESHOLD` and `MEMORY_USAGE_THRESHOLD`: The usage thresholds for CPU and memory. If usage exceeds these thresholds, an alert will be sent.

## Usage

To use the script, navigate to the project directory and run:

```bash
./health_monitor.sh
or you can add it to an hourly cron job using this command:
"0 * * * * /home/ahmed/Desktop/HealthMonitoringTool/health_monitor.sh >> /home/ahmed/Desktop/HealthMonitoringTool/logs/cron.log 2>&1"
change based on your file structure. 

## Logs

The script writes logs to the logs/health_monitor.log file. The logs include the collected metrics and any alerts that were sent.

## Dependencies

The script depends on the following Linux utilities:

-   top
-   free
-   grep
-   awk
-   bc
