#!/usr/bin/env bash

# Print the usage message
function printHelp () {
  echo "Usage: "
  echo "  ./multithreaded_runner.sh -w <workload_name> -p arg1=argvalue1 -p arg2=argvalue2"
  echo "  ./multithreaded_runner.sh -h|--help (print this message)"
  echo "    -w <workload> - workload name to launch"
  echo "    -p <ycsb_parameter> - a set of ycsb extra parameters to add. Should be in format '-p name=value'"
}

# Parse commandline args
ARGS=()
while getopts "h?w:p:" opt; do
  case "$opt" in
    h|\?)
      printHelp
      exit 0
    ;;
    w)  WORKLOAD=$OPTARG    # workload name
    ;;
    p)  ARGS+=("-p $OPTARG")
    ;;
  esac
done

if [ -z "${WORKLOAD}" ]; then
    echo "Workload -w parameter is mandatory! Please, specify it."
    exit 1;
fi

for threads in 25 50 75 100 125 150 175 200 250 300 400 500; do
 echo " >> Launching workload ${WORKLOAD} in ${threads} threads..."

 echo "mkdir -p ./results/4-nodes/couchbase/${WORKLOAD} && ./bin/ycsb run -s couchbase2 -P workloads/${WORKLOAD} -threads ${threads} -p statsexportfile=./results/4-nodes/couchbase/${WORKLOAD}/results.csv ${ARGS[@]}" | sh

 echo " << Finished workload ${WORKLOAD} execution in ${threads} threads!"
done