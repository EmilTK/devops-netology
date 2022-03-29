import json
import time
from datetime import date


def cpu_info():
    with open('/proc/loadavg', 'r') as f:
        cpu_la = f.readline().split(" ")[:3]
    return cpu_la


def mem_info():
    meminfo = {}
    with open('/proc/meminfo', 'r') as f:
        for line in f:
            meminfo[line.split(':')[0]] = line.split(':')[1].strip()
    return meminfo['MemFree']


def swap_info():
    with open('/proc/swaps', 'r') as f:
        for line1, line2 in zip(f, f):
            swap = line2.split()
    return (f'{swap[3]}/{swap[2]}')


def uptime_info():
    with open('/proc/uptime', 'r') as f:
        uptime_seconds = float(f.readline().split()[0])
    return uptime_seconds


def create_log():
    log = dict(
            timestamp = int(time.time()),
            cpu_la = cpu_info(),
            MemFree = mem_info(),
            swap = swap_info(),
            uptime = uptime_info()
            )
    filename = date.today().strftime('%y-%m-%d-awesome-monitoring.log')
    with open(f'/var/log/{filename}', 'a') as f:
        f.write(f'{json.dumps(log)}\n')


if __name__ == "__main__":
    create_log()