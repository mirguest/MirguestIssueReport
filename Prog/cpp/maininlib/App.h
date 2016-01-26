#ifndef App_h
#define App_h

class App {
    public:
        virtual int run() = 0;
};

extern App* app;

#endif
