import os
import xml.etree.ElementTree

BOOKMARKS_FILE = "/Users/chris/Library/Application Support/Tower/Bookmarks.plist"


class Bookmark(object):
    def __init__(self, **kwargs):
        self.uuid = kwargs.get("uuid", None)
        self.childNodes = kwargs.get("childnodes", [])
        self.isExpanded = kwargs.get("isexpanded", False)
        self.representedObject = kwargs.get("representedobject", "")
        self.sortingOrder = kwargs.get("sortingOrder", 1)
        self.title = kwargs.get("title", "")
        self.type_ = kwargs.get("type", "")

    def __repr__(self):
        return("<Bookmark(title=\"{0}\", representedobject=\"{1}\")>".format(
               self.title, self.representedObject))


def get_bookmarks(f=BOOKMARKS_FILE):
    bookmark_list = []

    if os.path.isfile(f):
        for bm in parse_bookmarks_file(f):
            bookmark_list.append(bm)

    return bookmark_list


def _process_elem_text(elem):
    out = None
    tag = elem.tag.lower()

    if tag == "string":
        out = elem.text
    elif tag == "true":
        out = True
    elif tag == "false":
        out = False
    elif tag == "array":
        out = []
    elif tag == "integer":
        out = int(elem.text)

    return out


def parse_bookmarks_file(f=BOOKMARKS_FILE):
    tree = xml.etree.ElementTree.parse(f)
    root = tree.getroot()

    if len(root.getchildren()) == 0 or root.getchildren()[0].tag != "dict":
        return

    bm_contain = root.getchildren()[0]

    for bm_dict in bm_contain.findall("dict"):
        bm_kw = {}
        last_key = ""

        for elem in bm_dict.getchildren():
            tag = elem.tag.lower()
            if tag == "key":
                last_key = elem.text.lower()
            else:
                bm_kw[last_key] = _process_elem_text(elem)

        yield Bookmark(**bm_kw)
