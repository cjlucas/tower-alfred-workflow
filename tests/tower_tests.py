from tests_helper import test_file

import unittest
import tower


class FolderTests(unittest.TestCase):
    def test_empty_folder(self):
        folders = tower.get_folder_list(test_file("bookmarks_empty_folder.xml"))

        self.assertEqual(len(folders), 2)
        self.assertEqual(len(folders["Default"].repositories), 0)
        self.assertEqual(len(folders["Empty Folder"].repositories), 0)

    def test_multiple_folders(self):
        folders = tower.get_folder_list(
            test_file("bookmarks_multiple_folders.xml"))

        self.assertEqual(len(folders), 3)

        self.assertIsNotNone(folders["Default"])
        self.assertEqual(len(folders["Default"].repositories), 1)

        repo = folders["Default"].repositories[0]
        self.assertEqual(repo.name, "Default Folder, Repo 1")

        self.assertIsNotNone(folders["Folder 1"])
        self.assertEqual(len(folders["Folder 1"].repositories), 3)

        repo = folders["Folder 1"].repositories[0]
        self.assertEqual(repo.name, "Folder 1, Repo 1")

        repo = folders["Folder 1"].repositories[1]
        self.assertEqual(repo.name, "Folder 1, Repo 2")

        repo = folders["Folder 1"].repositories[2]
        self.assertEqual(repo.name, "Folder 1, Repo 3")

        self.assertIsNotNone(folders["Folder 2"])
        self.assertEqual(len(folders["Folder 2"].repositories), 2)

        repo = folders["Folder 2"].repositories[0]
        self.assertEqual(repo.name, "Folder 2, Repo 1")

        repo = folders["Folder 2"].repositories[1]
        self.assertEqual(repo.name, "Folder 2, Repo 2")
