#!/bin/bash
declare -a searchPaths=("$PANDORA_LAR_PHYSICS_CONTENT_PATH/include" "$PANDORA_LAR_PHYSICS_CONTENT_PATH/src" "$PANDORA_LAR_PHYSICS_CONTENT_PATH/root")

for i in "${searchPaths[@]}"
do
	source $LAR_DEV_PATH/shell_scripts/del_trail_wspace.sh $i
done

source $LAR_DEV_PATH/shell_scripts/git_statuses.sh
