#!/bin/bash
(
if [[ $# -lt 1 ]]; then
    echo "Continuously recursively imports repositories defined in repositories file."
    echo "Use with vcstool https://github.com/dirk-thomas/vcstool"
    echo ""
    echo "Usage       : $0 [OPTIONS] DIR"
    echo "DIR         : base directory to find repositories file"
    echo ""
    echo "OPTIONS"
    echo "  -s SUFFIX : Repositories file suffix. (default: .repos)"
    echo ""
    echo "Example"
    echo "  For ROS user"
    echo "    $0 -s .rosintsall ~/catkin_ws/src"
    echo "    Note: better to set \"src\" directory as a target"
    exit 1
fi

SUFFIX=.repos
while [[ $# != 0 ]]; do
case ${1} in
    -s )
        SUFFIX=${2}
        shift 2

        if [[ $# == 0 ]]; then
            echo "Target directory is not specified"
            exit 1
        fi
        ;;
    *)
        DIR=${1}
        break
        ;;
esac
done

if [ -d "${DIR}" ]; then
    TARGET_DIR=$(cd "$(dirname "${DIR}")" || exit 1; pwd)/$(basename "${DIR}")
else
    echo "Target directory non-existent"
    exit 1
fi

echo "Target suffix : ${SUFFIX}"
echo "Start importing in ${TARGET_DIR}"
mapfile -t TARGETS < <(find "${TARGET_DIR}"/* -type f -name "*${SUFFIX}")
if [ ${#TARGETS[@]} -eq 0 ]; then
    echo "No repositories file found"
    exit 1
fi

DO=true
trap 'DO=false; exit 1' INT

COMPLETES=()
while [ ${#TARGETS[@]} != ${#COMPLETES[@]} ] && [ ${DO} == true ];do
    for ROSINSTALL in "${TARGETS[@]}"; do
        SKIP=false
        for COMPLETE in "${COMPLETES[@]}"; do
            if [[ ${ROSINSTALL} == "${COMPLETE}" ]]; then
                SKIP=true
                break
            fi
        done
        if [[ ${SKIP} == false ]]; then
            break
        fi
    done
    echo "Import ${ROSINSTALL}"
    vcs import "${TARGET_DIR}" < "${ROSINSTALL}"
    COMPLETES+=("${ROSINSTALL}")
    mapfile -t TARGETS < <(find "${TARGET_DIR}"/* -type f -name "*${SUFFIX}")
done

echo "Complete!"
