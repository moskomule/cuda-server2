#!/usr/bin/env bash

DEBUG_MODE=0
IMAGE_NAME_BASE="moskomule/cuda-server2:"
help() {
    echo "$ $0 CONTAINER_NAME CUDA_VER -p PORT [-v VOLUME -g GPU]
e.g., $ $0 $USER 101 -p 30022:22 -v /foo/bar:/foo/bar
    "
}

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]];then
    help
    exit 0
fi

if [[ $1 == "--debug" ]];then
    DEBUG_MODE=1
    shift 1
fi

if [[ $1 == "" ]] || [[ $2 == "" ]]; then
    help
    exit 1
else
    CONTAINER_NAME=$1
    case $2 in
        "92")
            IMAGE_NAME="${IMAGE_NAME_BASE}92"
        ;;
        "101")
            IMAGE_NAME="${IMAGE_NAME_BASE}101"
        ;;
        *)
            echo "no such cuda version $2"
            exit 1
        ;;
    esac
fi

# remove processed args
shift 2
# set optional args
PORT_OPTIONS=""
VOLUME_OPTIONS=""
GPU_OPTION=""


for OPT in "$@"; do
    
    case $OPT in
        "-v"|"--volume")
            VOLUME_OPTIONS="${VOLUME_OPTIONS}-v $2 "
            shift 2
        ;;
        
        "-p"|"--port")
            PORT_OPTIONS="${PORT_OPTIONS}-p $2 "
            shift 2
        ;;
        
        "-g"|"--gpus")
            if [[ ${GPU_OPTION} == "" ]];then
                GPU_OPTION=$2
                shift 2
            else
                echo "--gpus is already used (${GPU_OPTION})"
                exit 1
            fi
        ;;
        
    esac
done

if [[ ${PORT_OPTIONS} == "" ]];then
    echo "At least one port is required."
    exit 1
fi

if [[ ${GPU_OPTION} == "" ]];then
    GPU_OPTION="all"
fi

echo "building..."

if [[ ${DEBUG_MODE} == 1 ]];then
    
    echo "debug mode"
    echo "IMAGE_NAME=${IMAGE_NAME}"
    echo "CONTAINER_NAME=${CONTAINER_NAME}"
    echo "GPU_OPTION=${GPU_OPTION}"
    echo "PORT_OPTIONS=${PORT_OPTIONS}"
    echo "VOLUME_OPTIONS=${VOLUME_OPTIONS}"
    
else
    
    docker build \
    --build-arg image_name=${IMAGE_NAME} \
    --build-arg user_name=${CONTAINER_NAME} -t  \
    "${CONTAINER_NAME}_image" .
    
    echo "launching..."
    docker run -d \
    --gpus ${GPU_OPTION} \
    --privileged \
    --ipc=host \
    ${PORT_OPTIONS} \
    --name ${CONTAINER_NAME} \
    --restart always \
    ${VOLUME_OPTIONS} \
    "${CONTAINER_NAME}_image"
    
    echo "finished.

try

$ ssh -p XXXX ${CONTAINER_NAME}@localhost

and check if nvidia-smi or nvtop
    "
fi
