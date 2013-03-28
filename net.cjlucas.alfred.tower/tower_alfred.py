import fnmatch
import os

import alp
import tower

BOOKMARKS_FILE_STR = "~/Library/Application Support/Tower/Bookmarks.plist"

BOOKMARKS_FILE = os.path.expanduser(BOOKMARKS_FILE_STR)


def _get_fuzzy_query(term):
    """ Return a fuzzy pattern for term """

    term = term.lower()
    return "*{0}*".format("*".join(list(term)))


def _get_bookmark_for_title(bookmarks, title):
    for b in bookmarks:
        if b.title.lower() == title.lower():
            return b


def get_results(arg):
    """ Returns a list of Bookmark objects after a
    title search based on the given arg """
    bookmarks = tower.get_bookmarks(BOOKMARKS_FILE)

    bookmark_names = [b.title.lower() for b in bookmarks]

    results = fnmatch.filter(bookmark_names, _get_fuzzy_query(arg))

    bookmarks_filtered = [_get_bookmark_for_title(bookmarks, r)
                          for r in results]

    bookmarks_filtered = \
        sorted(bookmarks_filtered, key=lambda bm: bm.sort_order)
    return bookmarks_filtered


def get_items(arg):
    """ Get a list of alfred.Item objects """

    items = []

    for count, bookmark in enumerate(get_results(arg)):
        items.append(alp.Item(
            title=bookmark.title,
            subtitle=bookmark.path,
            arg=bookmark.path,
            icon="CloneRepoIcon.png")
        )

    return items
