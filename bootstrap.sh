#!/bin/bash
# Script is executed via iTerm2 when a tab is opened.

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_DIR="$ROOT/src"

function alert() {
  local standout=$(tput smso)
  local normal=$(tput sgr0)
  echo "${standout}$1${normal}"
}

pushd $ROOT > /dev/null 2>&1

for file in src/*.md; do
  base=$(basename $file)
  markdown --html4tags $file > "${base%.md}.html"
done

changes=$(git diff --name-only | grep *.html)
num_changes="${#changes[@]}"
if [ $num_changes -gt 0 ]; then
  # TODO on-click, open the repo in iTerm
  terminal-notifier -sound default \
    -ignoreDnD \
    -group 'robzienert.github.io' \
    -title 'robzienert.github.io' \
    -message "$num_changes unpublished devlog drafts" > /dev/null 2>&1
  alert "robzienert.github.io has unpublished drafts"
  echo $changes
fi
