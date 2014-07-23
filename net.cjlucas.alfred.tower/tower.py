import os
try:
    # cElementTree only available in 2.5+
    import xml.etree.cElementTree as ET
except:
    import xml.etree.ElementTree as ET


class Bookmark(object):
    def __init__(self, title, path, sort_order):
        self.title = title
        self.path = path
        self.sort_order = sort_order

    def __repr__(self):
        return("<Bookmark(title=\"{0}\", path=\"{1}\")>".format(
               self.title, self.path))


def get_bookmarks(f):
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

def _parse_dict_entry(elem):
    entry_kv = {}
    last_key = None

    for elem in elem.getchildren():
        tag = elem.tag.lower()

        if tag == "key":
            last_key = elem.text.lower()
        else:
            entry_kv[last_key] = _process_elem_text(elem)

    return entry_kv


def parse_bookmarks_file(f):
    tree = ET.parse(f)
    root = tree.getroot()

    root_dict = root.find("dict")
    entries = root_dict.find("array")

    entry_sort_order = 0
    for entry in entries.getchildren():
        if entry.tag != "dict":
            continue

        entry_kv = _parse_dict_entry(entry)
        entry_name = entry_kv["name"]
        entry_path = entry_kv["fileurl"][7:] # strip file://
        entry_sort_order += 1

        yield Bookmark(entry_name, entry_path, entry_sort_order)
