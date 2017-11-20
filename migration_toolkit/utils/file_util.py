#
#    Copyright (C) 2005  Distance and e-Learning Centre, 
#    University of Southern Queensland
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

import os
import os.path
import tempfile


def removeDir(dir):
    if os.path.exists(dir):
        files = os.listdir(dir)
        for file in files:
                file = dir + "/" + file
                if os.path.isdir(file):
                        removeDir(file)
                else:
                        os.remove(file)
        os.rmdir(dir)

def normalizePath(path):
    return path.replace("\\", "/")

def copyFile(fromFile, toFile):
    f = open(fromFile, "rb")
    data = f.read()
    f.close()
    f = open(toFile, "wb")
    f.write(data)
    f.close()

def copyDir(fromDir, toDir, excludingDirectories=[]):
    """
    copies a directory and all its subDirectories and files
    """
    fromDir = os.path.abspath(fromDir) + "/"
    toDir = os.path.abspath(toDir) + "/"
    
    for root, dirs, files in os.walk(fromDir):
        toRoot = os.path.join(toDir, root[len(fromDir):])
        if not os.path.exists(toRoot):
            os.makedirs(toRoot)
        for dir in list(dirs):
            if dir in excludingDirectories:
                dirs.remove(dir)
                continue
            dir = os.path.join(toRoot, dir)
            if not os.path.exists(dir):
                os.makedirs(dir)
        for file in files:
             copyFile(os.path.join(root, file), os.path.join(toRoot, file))
    
def makeDir(dir):
    if os.path.isdir(dir):
        return
    parent = os.path.dirname(dir)
    if not os.path.isdir(parent):
        makeDir(parent)
    os.mkdir(dir)


class tempDir:
    def __init__(self):
        self.__dir = tempfile.mkdtemp()

    def name(self):
        return self.__dir.replace("\\", "/")

    def remove(self):
        removeDir(self.__dir)
        self.__dir = None

    def __del__(self):
        if self.__dir!=None:
            self.remove()


def createTempDir():
    return tempDir()


