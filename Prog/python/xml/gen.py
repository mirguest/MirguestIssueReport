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

# collections to simplify input
# == collaborations ==
s_cls      = lambda top     : SubElement(top,     cal("collaborations"))
s_cl       = lambda cls, cid: SubElement(cls,     cal("collaboration"), {"id": cid})
s_cl_name  = lambda cl      : SubElement(cl,      foaf("name"))
s_cl_expno = lambda cl      : SubElement(cl,      cal("experimentNumber"))
# == organizations ==
s_orgs     = lambda top     : SubElement(top,     cal("organizations"))
s_org      = lambda orgs,oid: SubElement(orgs,    foaf("Organization"), {"id": oid})
s_org_name = lambda org     : SubElement(org,     foaf("name"))
s_org_oname= lambda org     : SubElement(org,     cal("orgName"))
s_org_oaddr= lambda org     : SubElement(org,     cal("orgAddress"))
s_org_ostat= lambda org     : SubElement(org,     cal("orgStatus"))
# == authors ==
s_authors  = lambda top     : SubElement(top,     cal("authors"))
s_person   = lambda authors : SubElement(authors, foaf("Person"))
s_per_np   = lambda person  : SubElement(person,  cal("authorNamePaper"))
s_per_gn   = lambda person  : SubElement(person,  foaf("givenName"))
s_per_fn   = lambda person  : SubElement(person,  foaf("familyName"))
s_per_coll = lambda person,cid:SubElement(person, cal("authorCollaboration"), {"collaborationid": cid}) 
s_per_affs = lambda person  : SubElement(person, cal("authorAffiliations"))
s_per_aff  = lambda affs, oid: SubElement(affs, cal("authorAffiliation"), {"connection":"Affiliated with", "organizationid":oid})
s_per_aids = lambda person  : SubElement(person, cal("authorids"))
s_per_aid_inspire = lambda authorids: SubElement(authorids, cal("authorid"), {"source": "Inspire ID"})
s_per_aid_orcid = lambda authorids: SubElement(authorids, cal("authorid"), {"source": "ORCID"})

def prettify(elem):
    """Return a pretty-printed XML string for the Element.
    """
    rough_string = ElementTree.tostring(elem, encoding='UTF-8')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="  ", encoding="UTF-8")

def build_collaborations(top):
    cls = s_cls(top)

    cl = s_cl(cls, "c1")
    name = s_cl_name(cl)
    name.text = "Daya Bay Collaboration"

    expno = s_cl_expno(cl)
    expno.text = "DAYA-BAY"
    pass

def build_organizations(top):
    orgs = s_orgs(top)
    
    # loop here, load all organizations
    org = s_org(orgs, "o0")
    name = s_org_name(org)
    name.text = "Institute of Modern Physics, East China University of Science and Technology, Shanghai"
    orgname = s_org_oname(org)
    orgname.text = "East China U. Sci. Tech."
    orgaddr = s_org_oaddr(org)
    orgaddr.text = "Institute of Modern Physics, East China University of Science and Technology, Shanghai"
    orgstat = s_org_ostat(org)
    orgstat.text = "member"

    pass

def build_authors(top):
    authors = s_authors(top)

    # Loop here, load all authors
    person = s_person(authors)
    authorNamePaper = s_per_np(person)
    authorNamePaper.text = "An, F.P."
    givenName = s_per_gn(person)
    givenName.text = "Feng Peng"
    familyName = s_per_fn(person)
    familyName.text = "An"
    # author collaboration
    authorCollaboration = s_per_coll(person, "c1")
    # author affiliations
    authorAffiliations = s_per_affs(person)
    # === one person can with different affiliations ===
    authorAffiliation = s_per_aff(authorAffiliations, "o0")

    # authorids 
    authorids = s_per_aids(person)
    aid_inspire = s_per_aid_inspire(authorids)
    aid_inspire.text = "INSPIRE-00447796"
    aid_orcid = s_per_aid_orcid(authorids)
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
