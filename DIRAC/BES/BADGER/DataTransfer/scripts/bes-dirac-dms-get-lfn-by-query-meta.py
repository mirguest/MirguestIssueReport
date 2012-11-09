#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

from DIRAC.Core.Base import Script

_fcType = 'FileCatalog'
Script.registerSwitch( "f:", "file-catalog=", "   Catalog client type to use (default %s)" % _fcType )

Script.parseCommandLine( ignoreErrors = False )

# By a Switch ?
for switch in Script.getUnprocessedSwitches():
    if switch[0].lower() == "f" or switch[0].lower() == "file-catalog":
        _fcType = switch[1]

# Create File Catalog Client
from DIRAC.Resources.Catalog.FileCatalogClient import FileCatalogClient
_client = FileCatalogClient("DataManagement/" + _fcType)

from DIRAC.DataManagementSystem.Client.FileCatalogClientCLI import FileCatalogClientCLI
_helper_fc_cli = FileCatalogClientCLI(_client)
_helper_create_query = _helper_fc_cli._FileCatalogClientCLI__createQuery

def getLFNsByQueryString(query):
    metadataDict = _helper_create_query(query)

    lfns = _client.findFilesByMetadata(metadataDict,'/')

    if not lfns["OK"]:
        import sys
        sys.stderr.write(repr(lfns))
        return list()

    return lfns["Value"]


query_string = " ".join(Script.getPositionalArgs())

for lfn in getLFNsByQueryString(query_string):
    print lfn
