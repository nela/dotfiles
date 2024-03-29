#!/bin/sh

branch_switched=$3

if [ "$branch_switched" != "1" ]
then
    exit 0
fi
echo "---- POST CHECKOUT ----"
current_branch=$(git rev-parse --abbrev-ref HEAD)
root_dir="$(pwd -P)"
info_dir="$root_dir/.git/info"

exclude_target='.gitignore'
if [ -f "$root_dir/$exclude_target.$current_branch" ]
then
	echo "Prepare to use .gitignore.$current_branch as exclude file"
    exclude_target=.gitignore.$current_branch
fi
cd "$info_dir" || exit
rm exclude
#ln -s $exclude_target exclude
echo "Copy .gitignore.$current_branch file in place of exclude"
cp "$root_dir/$exclude_target" exclude
echo "--- POST CHECKOUT END ---"