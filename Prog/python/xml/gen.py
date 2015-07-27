#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

# http://pymotw.com/2/xml/etree/ElementTree/create.html

from xml.etree.ElementTree import Element, SubElement, Comment
from xml.etree import ElementTree
from xml.dom import minidom

CAL = "{http://www.slac.stanford.edu/spires/hepnames/authors_xml/}"
FOAF = "{http://xmlns.com/foaf/0.1/}"

cal = lambda x: CAL+x
foaf = lambda x: FOAF+x

def prettify(elem):
    """Return a pretty-printed XML string for the Element.
    """
    rough_string = ElementTree.tostring(elem, encoding='utf-8')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="  ")

def build_collaborations(top):
    cls = SubElement(top, cal("collaborations"))

    cl = SubElement(cls, cal("collaboration"), {"id": "c1"})
    name = SubElement(cl, foaf("name"))
    name.text = "Daya Bay Collaboration"

    expno = SubElement(cl, cal("experimentNumber"))
    expno.text = "DAYA-BAY"
    pass

def build_organizations(top):
    orgs = SubElement(top, cal("organizations"))
    
    # loop here, load all organizations
    org = SubElement(orgs, foaf("Organization"), {"id": "o0"})
    name = SubElement(org, foaf("name"))
    name.text = "Institute of Modern Physics, East China University of Science and Technology, Shanghai"
    orgname = SubElement(org, cal("orgName"))
    orgname.text = "East China U. Sci. Tech."
    orgaddr = SubElement(org, cal("orgAddress"))
    orgaddr.text = "Institute of Modern Physics, East China University of Science and Technology, Shanghai"
    orgstat = SubElement(org, cal("orgStatus"))
    orgstat.text = "member"

    pass

def build_authors(top):
    authors = SubElement(top, cal("authors"))

    # Loop here, load all authors
    person = SubElement(authors, foaf("Person"))
    authorNamePaper = SubElement(person, cal("authorNamePaper"))
    authorNamePaper.text = "An, F.P."
    givenName = SubElement(person, foaf("givenName"))
    givenName.text = "Feng Peng"
    familyName = SubElement(person, foaf("familyName"))
    familyName.text = "An"
    # author collaboration
    authorCollaboration = SubElement(person, cal("authorCollaboration"), 
                                            {"collaborationid": "c1"})
    # author affiliations
    authorAffiliations = SubElement(person, cal("authorAffiliations"))
    authorAffiliation = SubElement(authorAffiliations, cal("authorAffiliation"),
                                    {"connection":"Affiliated with",
                                     "organizationid":"o0"})

    # authorids 
    authorids = SubElement(person, cal("authorids"))
    aid_inspire = SubElement(authorids, cal("authorid"), {"source": "Inspire ID"})
    aid_inspire.text = "INSPIRE-00447796"
    aid_orcid = SubElement(authorids, cal("authorid"), {"source": "ORCID"})
    aid_orcid.text = "0000-0002-8359-7804"

    
    pass


def main():
    ElementTree.register_namespace("cal", "http://www.slac.stanford.edu/spires/hepnames/authors_xml/")
    ElementTree.register_namespace("foaf", "http://xmlns.com/foaf/0.1/")
    top = Element("collaborationauthorlist")
    build_collaborations(top)
    build_organizations(top)
    build_authors(top)
    print prettify(top)

if __name__ == "__main__":
    main()
