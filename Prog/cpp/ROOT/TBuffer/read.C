
void read() {
		const char* olddir = gDirectory->GetPath();
		TFile* f = new TFile("test.root");
		f->Close();
		gDirectory->cd(olddir);


    ifstream ift("test.bin", ios::binary);

    char* tmpbuffer = new char[100000];
    ift.read(tmpbuffer, 100000);

    TBufferFile root_buffer(TBuffer::kRead);
    root_buffer.SetBuffer(tmpbuffer, 100000, kFALSE);

		TVirtualStreamerInfo* tvsi = root_buffer.GetInfo();

    TTree* tree = new TTree;

    tree->Streamer(root_buffer);

    Int_t x;
    tree->SetBranchAddress("x", &x);
    for (Int_t i = 0; i < tree->GetEntries(); ++i) {
        tree->GetEntry(i);
        std::cout << x << std::endl;
    }
}
