set -e
REPOS="valhalla-core valhalla-message-loader valhalla-derived-updater valkyrie"
BRANCHES="master develop"

function merge_repo {
    repo_name=$1
    repo_url=$2
    branch=$3

    if [ -z `git config --get remote.$repo_name.url` ]; then
	git remote add -f $repo_name $repo_url
    fi

    branch_spec=$repo_name/$branch
    git merge -s ours --no-commit $branch_spec
    git read-tree --prefix=$repo_name -u $branch_spec
    git commit -m "$repo_name: merged in $repo_name into valhalla project"
}

function get_remote {
    pushd . > /dev/null
    cd ../valhalla-parent/$1
    git config --get remote.origin.url
    popd > /dev/null
}


for repo in $REPOS; do
    for branch in $BRANCHES; do
	merge_repo $repo `get_remote $repo` $branch
    done
done
