#ifndef DB_IUpdate_h
#define DB_IUpdate_h

#include <string>

class IUpdate {
public:
    typedef std::string QueryString;
    typedef std::string RecordString;

    virtual bool update(const QueryString& qs, const RecordString& rs) = 0;

    virtual ~IUpdate(){};
};

#endif
