#!/bin/sh -l

uploadFiles=$(jq -r '.files[]' "$1")
commitMessage=$(jq -r '.commitMessage' "$1")

git config --global user.email "$3"

echo "$2" | gh auth login --with-token

for repo in $(jq -c '.repositories[]' "$1"); do
  repo_name=$(echo "$repo" | jq -r '.name')
  repo_user=$(echo "$repo" | jq -r '.user')
  repo_branch=$(echo "$repo" | jq -r '.branch')

  mkdir "workdir"
  cd workdir || echo 'cannot cd workdir'

  url=https://"$2"@github.com/"$repo_user"/"$repo_name".git

  git clone "$url" .
  exists=$(git ls-remote --heads "$url" "$repo_branch")
  if [ "$exists" ]; then
    git checkout "$repo_branch"
  else
    git checkout -b "$repo_branch"
  fi

  for file in $uploadFiles; do
    replacement=$(echo "$repo" | jq -r ".fileReplacements.\"$file\"")
    [ "$replacement" = "null" ] && filename="$file" || filename="$replacement"

    rm -r "$filename"
    cp -r ../"$file" "$filename"

    git add "$filename"
  done

  git commit -m "$commitMessage"
  git remote set-url origin "$url"
  git push --set-upstream origin "$repo_branch"

  pull_request_branch=$(echo "$repo" | jq -r '.pull_request.branch')
  if [ "$pull_request_branch" != "null" ]; then
    gh pr create -B "$pull_request_branch" --title "$4" --body ""
  fi

  cd ../
  rm -rf workdir
done
