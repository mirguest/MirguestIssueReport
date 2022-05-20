#ifndef DB_IInsert_h
#define DB_IInsert_h

#include <string>

class IInsert {
public:
    typedef std::string RecordString;

    virtual bool insert(const RecordString& rs) = 0;
    virtual ~IInsert() {};

};

#endif
