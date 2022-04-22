#!/bin/bash

for i in {0..1000}; do
	echo "*** Iteration ${i} ***"

	log_dir=logs/${i}
	output_dir=selfplay-training/bug-repro.${i}
	mkdir -p ${log_dir} ${output_dir} 
	mv selfplay-training/bug-repro selfplay-training/bug-repro.bak >/dev/null 2>&1
	ln -s bug-repro.${i} selfplay-training/bug-repro

	echo "Starting Docker compose"
	docker-compose -f compose/selfplay2.yml --env-file compose/selfplay2.env up >${log_dir}/compose.stdout 2>${log_dir}/compose.stderr&

	echo "Waiting for at least one model to have been trained"
	while true; do
		ls ${output_dir}/train/t0/checkpoint >/dev/null 2>&1
		if [[ $? -eq 0 ]]; then
			break
		fi
		sleep 5
	done

	echo "First model checkpoint written. Waiting 1h after this."
	sleep 3600

	echo "Trying to bring model down now."
	echo "If this hangs, then bug detected!"
	docker-compose -f compose/selfplay2.yml --env-file compose/selfplay2.env down
	wait
done
