#!D:\diplom\pyramid_alchemy\Scripts\python.exe
# EASY-INSTALL-ENTRY-SCRIPT: 'Pygments','console_scripts','pygmentize'
__requires__ = 'Pygments'
import re
import sys
from pkg_resources import load_entry_point

if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
    sys.exit(
        load_entry_point('Pygments', 'console_scripts', 'pygmentize')()
    )
