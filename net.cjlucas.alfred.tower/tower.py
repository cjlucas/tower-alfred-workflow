try:
    # cElementTree only available in 2.5+
    import xml.etree.cElementTree as ElementTree
except ImportError:
    import xml.etree.ElementTree as ElementTree


class Folder(object):
    def __init__(self, name):
        self.name = name
        self.repositories = []
        self.sub_folders = []

    def all_repositories(self):
        all_repositories = self.repositories
        for sub_folder in self.sub_folders:
            all_repositories += sub_folder.repositories

        return all_repositories


class Repository(object):
    def __init__(self, name, path):
        self.name = name
        self.path = path
        self.sort_order = 0

    def __repr__(self):
        return "<Repository(name=\"{0}\", path=\"{1}\", sort_order={2})>" \
               .format(self.name, self.path, self.sort_order)


class FolderList(object):
    def __init__(self):
        self.folders = {}

    def __getitem__(self, folder_name):
        return self.folders.get(folder_name)

    def __len__(self):
        return len(self.folders)

    def append(self, folder):
        self.folders[folder.name] = folder


def get_folder_list(xml_path):
    folder_list = FolderList()

    for folder in parse_bookmarks_file(xml_path):
        folder_list.append(folder)

    return folder_list


def _parse_dict(elem):
    entry_kv = {}
    last_key = None

    for elem in elem.getchildren():
        tag = elem.tag.lower()

        if tag == "key":
            last_key = elem.text.lower()
        else:
            entry_kv[last_key] = _process_element(elem)

    return entry_kv


def _process_element(elem):
    out = None
    tag = elem.tag.lower()

    if tag == "string":
        out = elem.text
    elif tag == "true":
        out = True
    elif tag == "false":
        out = False
    elif tag == "array":
        out = [_process_element(c) for c in elem.getchildren()]
    elif tag == "integer":
        out = int(elem.text)
    elif tag == "dict":
        out = _parse_dict(elem)

    return out


def _is_folder_entry(entry_kv):
    return "filereferenceurl" not in entry_kv


def _is_valid_repository_entry(entry_kv):
    return "filereferenceurl" in entry_kv and "fileurl" in entry_kv


def _process_repository_entry(entry_kv):
    title = entry_kv["name"]
    path = entry_kv["fileurl"][7:]  # strip file://

    return Repository(title, path)


def _process_folder_entry(entry_kv):
    folder = Folder(entry_kv["name"])

    for child_kv in entry_kv["children"]:
        if _is_folder_entry(child_kv):
            sub_folder = _process_folder_entry(child_kv)
            folder.sub_folders.append(sub_folder)
        elif _is_valid_repository_entry(child_kv):
            repository = _process_repository_entry(child_kv)
            folder.repositories.append(repository)

    return folder


def parse_bookmarks_file(f):
    tree = ElementTree.parse(f)
    root = tree.getroot()

    entry_elements = root.find("dict").find("array").getchildren()

    # get all top-level entries
    entry_kvs = [_parse_dict(elem)
                 for elem in entry_elements if elem.tag == "dict"]

    default_folder = Folder("Default")

    for entry_kv in entry_kvs:
        if _is_folder_entry(entry_kv):
            yield _process_folder_entry(entry_kv)
        elif _is_valid_repository_entry(entry_kv):
            repository = _process_repository_entry(entry_kv)
            default_folder.repositories.append(repository)

    yield default_folder