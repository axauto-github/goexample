#!/bin/bash

function usage {
    echo "Usage"
    echo "$0 [options] .applatix-directory"
    echo
    echo "Options:"
    echo "    -d    Enable debug mode to print out the internal service templates converted from the yaml specs."
    echo "    -p url"
    echo "          Post all yaml files to the specified axops server url, e.g. http://axops:8085/v1"
    echo
}

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -d)
        debug_option="$key"
        shift
        ;;
        -h|--help)
        usage
        exit 0
        ;;
        -p)
        post_option="-p ${2}"
        shift
        shift # past argument
        ;;
        -*)
        unknown_key="$key"
        break
        ;;
        *)
        src_dir="$key"
        shift
        ;;
    esac
done

if [ -n "$unknown_key" ]
then
    echo
    echo Invalid option: "$unknown_key"
    echo
    usage
    exit 1
fi

if [ -z "$src_dir" ]
then
    usage
    exit 1
fi

SRC_DIR="$(cd "${src_dir}" && pwd)"
if [ -z ${SRC_DIR} ]
then
    echo
    echo Invalid directory: ${src_dir}
    usage
    exit 1
fi

docker run -v "$SRC_DIR":"$SRC_DIR" docker.applatix.io/axops:latest /axops/bin/axyamlcheck ${debug_option} ${post_option} ${SRC_DIR}
