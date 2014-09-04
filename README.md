tower-alfred-workflow [![Build Status](https://travis-ci.org/cjlucas/tower-alfred-workflow.svg?branch=master)](https://travis-ci.org/cjlucas/tower-alfred-workflow)
=====================

An Alfred workflow for searching/opening Tower git repositories

![Image alt](https://raw.github.com/cjlucas/tower-alfred-workflow/master/screenshot.png)

The packaged workflow can be downloaded [here](https://github.com/cjlucas/tower-alfred-workflow/raw/master/tower-alfred-workflow.alfredworkflow).

Changelog
---------

- v2.3 (September 4, 2014)
  - Removed support for Ruby 1.9.3 (not installed by default on version of OS X)
  - Fixed typo in modifier key description (#7)
  - Fixed bug that failed to open repositories with paths that contain spaces (#8)

- v2.2 (August 14, 2014)
  - Added support for modifier keys
    - Browse in Alfred (cmd)
    - Reveal in Finder (shift)
    - Open in Terminal (alt)
    - Copy to Clipboard (fn)
  - Dropped support for Mountain Lion

- v2.1 (August 10, 2014)
  - Folder support

- v2.0 (July 22, 2014)
  - Added support for Tower 2
  - Removed support for Tower 1

- v1.3 (May 16, 2014)
  - Added support for finding Tower.app in subdirectories of /Applications

- v1.2 (March 29, 2013)
  - [alleyoop](http://www.alfredforum.com/topic/1582-alleyoop-update-alfred-workflows/) support
  - speed improvements

- v1.1 (March 27, 2013)
  - improvement: sort bookmarks as they're sorted in Tower.app
  - improvement: search repository paths in addition to bookmark names

- v1.0 (March 26, 2013)
  - Initial release

TODO
----
- Add support for opening in external editor
