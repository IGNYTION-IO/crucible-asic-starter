"""Local entrypoints for portable cleanup and WSL physical verification."""

import argparse
from pathlib import Path
import subprocess
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
    actions = {"clean_files": clean_files, "physical": physical, "ensure_stage": ensure_stage}
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=actions)
    parser.add_argument("project_root")
    parser.add_argument("files", nargs="*")
    args = parser.parse_args()
    try:
        result = actions[args.command](args.project_root, args.files)
    except (OSError, ValueError) as error:
        print(f"Operation failed: {error}", file=sys.stderr)
        return 1
    return result or 0


def physical(project_root, arguments):
    if arguments:
        raise ValueError("The physical command takes only the project root")
    root = Path(project_root).resolve()
    return subprocess.run(
        [sys.executable, "-B", str(root / "11_physical_verification/run_checks.py")],
        cwd=root,
    ).returncode


def ensure_stage(project_root, arguments):
    if len(arguments) != 3:
        raise ValueError("ensure_stage requires: required_file stage_directory target")
    root = Path(project_root).resolve()
    required = (root / arguments[0]).resolve()
    stage = (root / arguments[1]).resolve()
    if not required.is_relative_to(root) or not stage.is_relative_to(root):
        raise ValueError("Prerequisite paths must stay inside the project")
    if required.is_file():
        return 0
    print(f"Building missing prerequisite: {required}", flush=True)
    result = subprocess.run(["make", "-C", str(stage), arguments[2]], cwd=root)
    if result.returncode:
        return result.returncode
    if not required.is_file():
        raise ValueError(f"Prerequisite stage completed without producing {required}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
