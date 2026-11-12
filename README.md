# utils

Small shell scripts for everyday git and file chores.

## Install

Clone the repo and add it to your PATH, e.g. in `~/.zshrc`:

```sh
export PATH="$PATH:$HOME/Development/sz-utils"
```

## Scripts

Each script has a usage comment at the top.

| Script | What it does |
| --- | --- |
| `git-clean.sh [-r]` | Delete local branches merged into HEAD; with `-r`, also merged branches on origin older than 30 days. |
| `git-find-large-files.sh` | Show the 10 largest objects in the repo's history. |
| `git-find-blob.sh <sha> [log opts]` | List the commits that contain a given blob (e.g. a SHA from `git-find-large-files.sh`). |
| `git-set-author.sh <email> [name]` | Set `user.email` / `user.name` in every repo under the current directory. |
| `run_git_recursively.sh <command>` | Run a command in every repo under the current directory. |
| `translit.sh [dir]` | Rename files and folders from Cyrillic to Latin, recursively. |
| `devbox.sh` | Functions to mount and rsync code on a remote dev server (ssh host `devbox` by default, see `DEVBOX_REMOTE`). Source it: `source devbox.sh`. |
