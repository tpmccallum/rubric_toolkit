from resolve_missing_datastreams import *

def testGetMissingDatastreams():
    dsList = getMissingDatastreams("testData/foxmlFile", "FULLTEXT")
    assert False