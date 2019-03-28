#!/usr/bin/env bash
# ファイルをConfigMapおよびSecrets形式に変換するスクリプト
# 改行からカンマ区切り等への変換は呼び出し側で行ってください。

set -e

usage_exit() {
    echo "
Usage: $0 (environment) [-f]
  -f) config path:  set config file path (required)
    " 1>&2
    exit 1
}
while getopts f:h OPT
do
    case ${OPT} in
        f)
            CONFIG_PATH=$OPTARG
            ;;
        h)
            usage_exit
            ;;
        \?)
            usage_exit
            ;;
    esac
done
shift $(($OPTIND - 1))

ENV=$1
if [[ -z ${ENV} ]]; then
    usage_exit
fi

if [ -z ${CONFIG_PATH} ]; then
    usage_exit
fi

if [ ! -d ${CONFIG_PATH} ]; then
    echo "Not found config path: ${CONFIG_PATH}"
fi

###
# echo config file body as key=value format
# e.g.
# key1=value1
# key2=value2
create_params() {
    # config file prefix
    prefix="${1}."
    config_path=$2
    config_type=$3

    if [ ! -d "${config_path}" ]; then
        echo "No files provided"
        exit 1
    fi

    needs_encode=""
    if [ "${config_type}" == "secrets" ]; then
        needs_encode=1
    fi

    files="${config_path}/${config_type}/${prefix}*"
    for file in ${files}; do
        contents=''
        if [ ${needs_encode} ]; then
            contents=$(base64 <${file})
        else
            contents=$(cat ${file} | perl -pe 's/\n/\\n/')
        fi
        filename=$(basename ${file//\./\\.})
        # Replace filename `dev.config.json` to `config.json` for key
        key=${filename#${prefix}}
        echo "${config_type}\.${key}=${contents//,/\\,}"
    done
}

for CONFIG_TYPE in "configs" "secrets" ; do
    create_params ${ENV} ${CONFIG_PATH} ${CONFIG_TYPE}
done
