"""Portable cleanup of explicitly named generated files."""

import argparse
from pathlib import Path
import sys


def clean_files(project_root, filenames):
    root = Path(project_root).resolve()
    if not root.is_dir():
        raise ValueError(f"Project directory does not exist: {root}")
    paths = []
    for filename in filenames:
        path = root / filename
        if not path.resolve().is_relative_to(root):
            raise ValueError(f"Cleanup path is outside the project: {filename}")
        if path.is_dir():
            raise ValueError(f"Cleanup expects a file, not a directory: {filename}")
        paths.append(path)

    removed = 0
    for path in paths:
        present = path.exists() or path.is_symlink()
        path.unlink(missing_ok=True)
        removed += present
    print(f"Cleaned {removed} generated file(s).")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["clean_files"])
    parser.add_argument("project_root")
    parser.add_argument("files", nargs="*")
    args = parser.parse_args()
    try:
        clean_files(args.project_root, args.files)
    except (OSError, ValueError) as error:
        print(f"Cleanup failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
