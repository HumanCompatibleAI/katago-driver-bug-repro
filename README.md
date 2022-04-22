This is repository contains scripts needed to replicate an NVidia driver bug occurring when executing KataGo. See [this forum post](https://forums.developer.nvidia.com/t/kernel-oops-null-pointer-dereference-when-closing-cuda-application-katago/211270/3) for more information.

To reproduce the error, run from the repository root on a machine with at least 2 GPUs:
```
docker-compose -f compose/selfplay2.yml --env-file compose/selfplay2.env up
```

Wait for it to run. Wait at least long enough for GPU utilization to be high (for about the first 30m, the code just uses CPU, not GPU). Then Ctrl-C the job. Sometimes it will hang, with a kernel OOPS. This seems to be more likely the longer the job has been running.

If you have a machine with 8 or more GPUs, you could also run:

``` 
docker-compose -f compose/selfplay8.yml --env-file compose/selfplay8.env up
```

Most of our errors have been with servers on 8 GPUs, but we have observed one error on a server with 4 GPUs, so the number of GPUs does not seem critical to reproducing it.
