# nagios_plugins

## Customized Plugins intended for use with Nagios Core 4.x and NagiosGraph

### check_mem_nc.sh
Reports memory statistics but the real metric is calculated without taking into account cached memory - The plugin reports by considering cached memory free

### check_tcp_stats.sh
Reports:

    - Total Active TCP Connections (-o all)
    - Total Established TCP Connections (-o est)
    - Number of Retransmitted TCP Packets (-o retr)
