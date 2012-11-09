#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

from DIRAC.Core.Base import Script

_fcType = 'FileCatalog'
Script.registerSwitch( "f:", "file-catalog=", "   Catalog client type to use (default %s)" % _fcType )

Script.parseCommandLine( ignoreErrors = False )

# Get the File List By Dataset Name
from DIRAC.Resources.Catalog.FileCatalogClient import FileCatalogClient

# By a Switch ?
for switch in Script.getUnprocessedSwitches():
    if switch[0].lower() == "f" or switch[0].lower() == "file-catalog":
        _fcType = switch[1]

_client = FileCatalogClient("DataManagement/" + _fcType)

def getLFNsByDataset(dataset):
    result = _client.getMetadataSet(dataset, True)
    if not result["OK"]:
        return list()
    if not result["Value"]:
        import sys
        sys.stderr.write("\nWARNNING: datatset(%s) does not exist.\n"%dataset)
        return list()
    metadataDict = result["Value"]

    lfns = _client.findFilesByMetadata(metadataDict,'/')

    if not lfns["OK"]:
        return list()

    return lfns["Value"]

for dataset in Script.getPositionalArgs():
    for lfn in getLFNsByDataset(dataset):
        print lfn
