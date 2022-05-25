This is repository contains scripts needed to replicate an NVidia driver bug occurring when executing KataGo. See [this forum post](https://forums.developer.nvidia.com/t/kernel-oops-null-pointer-dereference-when-closing-cuda-application-katago/211270/3) for more information.

We use submodules to contain the appropriate version of KataGo, to clone this repository use:
```
git clone --recurse-submodules https://github.com/HumanCompatibleAI/katago-driver-bug-repro.git
```

To reproduce the error, run from the repository root on a machine with at least 7 GPUs:
```
bash loop.sh
```

This configuration reliably replicates the problem, but you can also run this with a different number of GPUs: we currently support 2, 3, 4 or 8 GPUs. For example: 

```
bash loop.sh 4
```

A different number of GPUs can be supported by adding files `compose/crashN.{yml,env}` and `configs/crashN.cfg` appropriately modified.

To run on a different number of GPUs than {2,3,4,7}, it will be necessary to add a file `compose/crashN.{yml,env}` and `configs/crashN.cfg` -- this can be done by small modifications from the existing files.

You must run this with Docker Compose v1.28.0 or later (older versions do not support GPU reservations). The first time you run this, it may take a while on the first iteration as the images need to be pulled and built.

This script will repeatedly start Docker containers, wait 45s, and stop them. The bug occurs when the processes terminate, closing the GPU, but only if some work has already performed.

Logs are stored in `bug-repro-logs`.

In our experiments, the error often occurs within a few iterations, and has always ocurred within 10 iterations.
