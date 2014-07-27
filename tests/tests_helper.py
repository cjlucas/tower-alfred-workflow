import nose.tools
import os
import sys

@nose.tools.nottest
def test_file(file_name):
    tests_dir = os.path.dirname(__file__)
    return os.path.join(tests_dir, "files", file_name)

sys.path.insert(0, os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    "../net.cjlucas.alfred.tower")))
