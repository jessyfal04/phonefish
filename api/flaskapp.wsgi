import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0, "/home/yepssy/code/phonefish/api")

from app import app as application
