
void read() {

    ifstream ift("test.bin", ios::binary);

    char* tmpbuffer = new char[100000];
    ift.read(tmpbuffer, 100000);

    TBufferFile root_buffer(TBuffer::kRead);
    root_buffer.SetBuffer(tmpbuffer, 100000, kFALSE);

    TTree* tree = new TTree;

    tree->Streamer(root_buffer);

    Int_t x;
    tree->SetBranchAddress("x", &x);
    for (Int_t i = 0; i < tree->GetEntries(); ++i) {
        tree->GetEntry(i);
        std::cout << x << std::endl;
    }
}
