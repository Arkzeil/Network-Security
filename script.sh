#!/bin/bash

directory_name="google"
compressed_file_name="google.tar"
process_name="server.py"

# Function to handle cleanup, kill server if the segmentation fault occurs
cleanup() {
    local exit_code=$?

    echo "Cleaning up..."
    
    if ps -fa | grep $process_name > /dev/null
    then
        # If the process is running, kill it, this is for address reuse immediately
        pkill -f "$process_name"
        echo "Process '$process_name' killed."
    fi

    echo "Error: An unexpected event occurred (Exit code: $exit_code)"

    exit 1
}

# Set up the trap to catch signals(errors (ERR), termination signals (SIGTERM, SIGINT), and segmentation faults (SIGSEGV)) and call the cleanup function
trap 'cleanup' SIGTERM SIGINT SIGSEGV


# Check if the directory exists
if [ -d $directory_name ]; 
then
    # If the directory exists, delete it
    echo "Deleting existing directory: $directory_name"
    rm -rf $directory_name
fi

# Untar the file
echo "Untarring google.tar"
tar -xf $compressed_file_name

if ps -fa | grep $process_name > /dev/null
then
    # If the process is running, kill it, this is for address reuse immediately
    pkill -f "$process_name"
    echo "Process '$process_name' killed."
fi

python3 server.py &
#for not using prevous cache, delete user profile first
rm -rf ./temp_chrome_data;google/chrome/chrome --no-first-run --user-data-dir=./temp_chrome_data http://localhost:8080/312552025_poc1.html &

sleep 20

if pgrep -f "chrome --no-first-run --user-data-dir=./temp_chrome_data" > /dev/null; 
then
    # If such processes are running, kill them
    pkill -f "chrome --no-first-run --user-data-dir=./temp_chrome_data"
    echo "Chrome processes launched by the script are closed."
    rm -rf ./temp_chrome_data;google/chrome/chrome --no-first-run --user-data-dir=./temp_chrome_data http://localhost:8080/312552025_poc1.html
fi