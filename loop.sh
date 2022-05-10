#!/bin/bash

num_gpus=${1:-7}
wait_time={$2:-60}

docker-compose --version
for i in {0..100}; do
    echo "*** Iteration ${i} ***"

    output_dir=bug-repro-logs/run-${i}
    mkdir -p ${output_dir}
    mv bug-repro-logs/active bug-repro-logs/active.bak >/dev/null 2>&1
    ln -s run-${i} bug-repro-logs/active

    echo "Starting Docker compose"
    docker-compose \
        -f compose/crash${num_gpus}.yml \
        --env-file compose/crash${num_gpus}.env \
        up \
        >${output_dir}/compose.stdout \
        2>${output_dir}/compose.stderr&

    echo "Waiting for ${wait_time} seconds"
    for i in $(seq $wait_time)
    do
        echo -n .
        sleep 1
    done
    echo -e "\nDone waiting."

    echo "Trying to bring docker service down now."
    echo "If this hangs, then bug detected!"
    docker-compose -f compose/crash${num_gpus}.yml --env-file compose/crash${num_gpus}.env down
    wait
done
