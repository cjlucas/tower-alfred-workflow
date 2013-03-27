import fnmatch

import alfred
import gittower

BOOKMARKS_FILE = "/Users/chris/Library/Application Support/Tower/Bookmarks.plist"


def _get_fuzzy_query(term):
    """ Return a fuzzy pattern for term """

    return "*{0}*".format("*".join(list(term)))


def _get_bookmark_for_title(bookmarks, title):
    for b in bookmarks:
        if b.title == title:
            return b


def get_results(arg):
    """ Returns a list of Bookmark objects after a
    title search based on the given arg """
    bookmarks = gittower.get_bookmarks(BOOKMARKS_FILE)

    bookmark_names = [b.title for b in bookmarks]

    results = fnmatch.filter(bookmark_names, _get_fuzzy_query(arg))

    return [_get_bookmark_for_title(bookmarks, r) for r in results]


def get_items(arg):
    """ Get a list of alfred.Item objects """

    items = []

    attrib = {"uid": alfred.uid(0), "arg": "somethinghere"}
    for count, bookmark in enumerate(get_results(arg)):
        attrib = {"uid": alfred.uid(count),
                  "arg": bookmark.path}

        items.append(alfred.Item(
            attributes=attrib,
            title=bookmark.title,
            subtitle=bookmark.path,
            icon="CloneRepoIcon.png")
        )

    return items
