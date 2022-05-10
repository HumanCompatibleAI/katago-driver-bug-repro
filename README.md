This is repository contains scripts needed to replicate an NVidia driver bug occurring when executing KataGo. See [this forum post](https://forums.developer.nvidia.com/t/kernel-oops-null-pointer-dereference-when-closing-cuda-application-katago/211270/3) for more information.

We use submodules to contain the appropriate version of KataGo, to clone this repository use:
```
git clone --recurse-submodules https://github.com/HumanCompatibleAI/katago-driver-bug-repro.git
```

To reproduce the error, run from the repository root on a machine with at least 7 GPUs:
```
bash loop.sh
```

You can also run this on a machine with 3 GPUs. It should still reproduce the problem, but it may take longer:
```
bash loop.sh 3
```

You must run this with Docker Compose v1.28.0 or later (older versions do not support GPU reservations). The first time you run this, it may take a while on the first iteration as the images need to be pulled and built.

This script will repeatedly start Docker containers, wait 45s, and stop them. The bug occurs when the processes terminate, closing the GPU, but only if some work has already performed.

Logs are stored in `bug-repro-logs`.

In our experiments, the error often occurs within a few iterations, and has always ocurred within 10 iterations.
