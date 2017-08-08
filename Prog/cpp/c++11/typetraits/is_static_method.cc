/*
 * g++ -std=c++11 is_static_method.cc
 */

#include <type_traits>
#include <iostream>
namespace SniperLog
{
    int LogLevel = 3;
    //2:debug, 3:info, 4:warn, 5:error, 6:fatal
    int logLevel() { 
        return LogLevel; 
    }

    //return the global scope and objName string
    const std::string& scope() {
	static const std::string NonScope = "SNiPER:";
	return NonScope;
    }
    const std::string& objName() {
        static const std::string NonName = "NonName";
	return NonName;
    }

    class LogHelper
    {
    public :

	LogHelper(int flag,
		  int level,
		  const std::string& scope,
		  const std::string& objName,
		  const char* func
		  )
	    : m_active(flag >= level)
	{
	}

	~LogHelper() {
        }

	LogHelper& operator<<(std::ostream& (*_f)(std::ostream&)) {
            if ( m_active ) _f(std::cout);
	    return *this;
        }

	template<typename T>
	LogHelper& operator<<(const T& t)
	{
	    if ( m_active ) std::cout << t;
	    return *this;
	}


        private :

            const bool m_active;
    };

}

using SniperLog::logLevel;
using SniperLog::scope;
using SniperLog::objName;



#define SNIPERLOG_OBJ(Flag) \
       SniperLog::LogHelper(\
        Flag,                                   \
        logLevel(),                             \
        scope(),                                \
	objName(),				\
        __func__                                \
        )
#define SNIPERLOG_GLB(Flag)			\
       SniperLog::LogHelper(\
        Flag,                                   \
        logLevel(),                             \
        scope(),                                \
	::objName(),	            		\
        __func__                                \
        )

#define LogTest   SNIPERLOG(0)
#define LogDebug  SNIPERLOG(2)
#define LogInfo   #if define(this) SNIPERLOG_OBJ(3) #else SNIPERLOG_GLB(3) #endif
#define LogWarn   SNIPERLOG(4)
#define LogError  SNIPERLOG(5)
#define LogFatal  SNIPERLOG(6)



class A {
public:
    static void mymethod() {
        LogInfo << "hello" << std::endl;
#if defined(this)
	std::cout << this << std::endl;
#endif
    }

    const std::string& objName() { return m_name; }

private:
    std::string m_name;
};

int main() {
    A::mymethod();
}
