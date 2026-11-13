#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "[-] This script must be run with root privileges. Re-running with sudo..."
    exec sudo "$0" "$@"
fi

GENERATED_AT=$(date)
UPTIME_TEXT=$(uptime -p)
DISK_USAGE=$(df -P / | awk 'NR == 2 {print $5}')

MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')

usage_num=${DISK_USAGE%\%}
if [ "$usage_num" -ge 80 ]; then
    DISK_STATUS="WARNING"
else
    DISK_STATUS="OK"
fi

TEMP_FILE="index.html"
GITHUB_URL="https://github.com/TV20260/Linux-Administration"

cat > "$TEMP_FILE" <<EOF

<!DOCTYPE html>
<html>
<head>
<title>Week 3</title>
<style>
body {
    background-color: #1D1E18;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: #D9FFF5;
    margin: 0;
    padding: 20px;
    text-align: center;
}

.divStyle {
    background-color: #B9F5D8;
    color: #6B8F71;
    width: 400px;
    padding: 20px;
    margin: 20px auto;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    text-align: center;
    border: 3px solid #AAD2BA;
}
</style>
</head>
<body>
<h1>Week 3</h1>
<div class="divStyle">
    <h2>Server status</h2>
    <table style="text-align: left;">
        <tr>
            <th>Report generated:</th>
	    <td>$GENERATED_AT</td>
        </tr>
        <tr>
            <th>Server uptime:</th>
            <td>$UPTIME_TEXT</td>
        </tr>
        <tr>
            <th>Disk usage:</th>
            <td>$DISK_USAGE</td>
        </tr>
        <tr>
            <th>Total memory:</th>
            <td>$MEM_TOTAL MiB</td>
        </tr>
        <tr>
            <th>Memory available:</th>
            <td>$MEM_AVAILABLE MiB</td>
        </tr>
        <tr>
            <th>Disk status:</th>
            <td>$DISK_STATUS</td>
        </tr>
    </table>
    <h2>Git-repo</h2>
    <a href=$GITHUB_URL>Link to git-repo</a>
</body>
</html>
EOF

echo "Success! index.html generated successfully."
