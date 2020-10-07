
#define DCL_G4_RUNACTION(Runaction) \
    class _Svc_##Runaction##_ : \
        public Svc, public Runaction \
    { \
    }

class Svc {

};

class RunAction {

};

DCL_G4_RUNACTION(RunAction);

int main()
{
    _Svc_RunAction_ sra;

}
