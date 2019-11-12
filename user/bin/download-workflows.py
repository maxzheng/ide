#!/usr/bin/env python3

from pathlib import Path
from subprocess import check_call
import sys

sys.path.append('/home/mzheng/workspace/data-flows')

from workflows.config import production  # noqa


def main():
    gs_folder = production.GS_WORKFLOWS_FOLDER
    path = ''
    cp_cmd = r'-m rsync -r -d -x ".*\.pyc$|.*/\..*|\..*"'

    if not Path(f'workflows/{path}').exists():
        print(f'! workflows/{path} does not exist')
        sys.exit(1)

    check_call(f'gsutil {cp_cmd} {gs_folder}/{path} workflows/{path}', shell=True)
    print('Download completed.')


try:
    main()

except KeyboardInterrupt:
    print()
