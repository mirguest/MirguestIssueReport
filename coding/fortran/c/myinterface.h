#ifndef myinterface_h
#define myinterface_h

extern "C" {
    void finit();
    void fexecute();
    
    void init();

    void execute();

    struct Pod {
        float x;
        float y;
        float z;
        float t;
    };

    void set_pod(float x, float y, float z, float t);
    void get_pod(Pod* pod);
}

#endif
