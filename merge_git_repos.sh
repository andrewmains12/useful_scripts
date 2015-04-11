#!/bin/bash
set -e

# Found this; not sure if it works. Probably largely copypasted off the internet.

if [[ $# -lt 1 ]]; then
  echo "Usage: merge_git_repos.sh <repos> [branches]"
  echo "Merge branches (default master, develop) from repos into this repo."
  exit 1
fi

REPOS="${1}"
BRANCHES="${2-master develop}"

function merge_repo {
    repo_url=$1
    branch=$2
    repo_name="$(basename repo_url)"
    repo_name="${repo_name%.*}"

    if [ -z `git config --get remote.$repo_name.url` ]; then
	git remote add -f "${repo_name}" "${repo_url}"
    fi

    branch_spec=$repo_name/$branch
    git merge -s ours --no-commit $branch_spec
    git read-tree --prefix=$repo_name -u $branch_spec
    git commit -m "$repo_name: merged in $repo_name"
}

for repo in $REPOS; do
    for branch in $BRANCHES; do
	merge_repo "${repo}" "${branch}"
    done
done
