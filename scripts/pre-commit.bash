#!/usr/bin/env bash

printf "\e[33;1m%s\e[0m\n" 'Pre-Commit'

# Undo the stash of the files
pop_stash_files() {
    if [ -n "$hasChanges" ]; then
        printf "\e[33;1m%s\e[0m\n" '=== Applying git stash changes ==='
        git stash pop
    fi
}

# Stash unstaged files
hasChanges=$(git diff)
if [ -n "$hasChanges" ]; then
    printf "\e[33;1m%s\e[0m\n" 'Stashing unstaged changes'
    git stash push --keep-index
fi

# Flutter formatter
printf "\e[33;1m%s\e[0m\n" '=== Running Flutter Formatter ==='
flutter format .

hasNewFilesFormatted=$(git diff)
if [ -n "$hasNewFilesFormatted" ]; then
    git add .
    printf "\e[33;1m%s\e[0m\n" 'Formatted files added to git stage'
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running Flutter Formatter'

# Flutter Analyzer
printf "\e[33;1m%s\e[0m\n" '=== Running Flutter analyzer ==='

if ! flutter analyze; then
    printf "\e[31;1m%s\e[0m\n" '=== Flutter analyzer error ==='
    pop_stash_files
    exit 1
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running Flutter analyzer'

# Unit tests
#printf "\e[33;1m%s\e[0m\n" '=== Running Unit Tests ==='
#if [ -d "test" ]; then
#
#  if ! flutter test; then
#      printf "\e[31;1m%s\e[0m\n" '=== Unit tests error ==='
#      pop_stash_files
#      exit 1
#  fi
#fi
#printf "\e[33;1m%s\e[0m\n" 'Finished running Unit Tests'
#printf '%s\n' "${avar}"

pop_stash_files
