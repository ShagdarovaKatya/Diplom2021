#!D:\diplom\pyramid_alchemy\Scripts\python.exe
# EASY-INSTALL-ENTRY-SCRIPT: 'pyramid-scaffold','console_scripts','initialize_pyramid_scaffold_db'
__requires__ = 'pyramid-scaffold'
import re
import sys
from pkg_resources import load_entry_point

if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
    sys.exit(
        load_entry_point('pyramid-scaffold', 'console_scripts', 'initialize_pyramid_scaffold_db')()
    )
