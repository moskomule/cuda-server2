# cuda-server2
![Docker Automated build](https://img.shields.io/docker/cloud/automated/moskomule/cuda-server2)

Renewed cuda-server for my research. `cuda-server2` has the latest PyTorch, ipython etc., as well as conda environment and linuxbrew, by default.

Note that `cuda-server2` may not be fully secure, so use it with care in a secure environment with users whom you can trust.

## Requirements

Check [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) page.

**Make sure you have installed the NVIDIA driver and Docker 19.03 for your Linux distribution.**

## Usage

### Setup

```shell
# chmod 777 run.sh
./run.sh CONTAINER_NAME CUDA_VERSION USER_OPTIONS
```

where

* `CONTAINER_NAME` is any name you like
* `CUDA_VERSION` is currently 92 or 101
* `USER_OPTIONS` includes
    - PORTS e.g., `-p 30022:22`. *Do not forget to specify at least one port for port 22*
    - VOLUMES e.g., `-v $HOME/Download:/home/user/Download`
    - GPU e.g., `all` (default), `"'devices=0,1'"`. This option corresponds `--gpus` of [nvidia-docker](https://github.com/NVIDIA/nvidia-docker#usage)


### Access

```shell
ssh -p XXXXX:22 CONTAINER_NAME@localhost
```

The default password is `Docker!`.