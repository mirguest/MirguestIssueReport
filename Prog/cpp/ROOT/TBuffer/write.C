TTree* create_dummy_tree() {

    TTree* tree = new TTree;
    Int_t x;
    tree->Branch("x", &x, "x/I");

    for (Int_t i = 0; i < 100; ++i) {
        x = i;
        tree->Fill();
    }

    return tree;
}

void write() {

    TTree* tree = create_dummy_tree();

    TBufferFile root_buffer(TBufferFile::kWrite);

    tree->Streamer(root_buffer);
    TStreamerInfo * tsi_tree = new TStreamerInfo(TTree::Class());
    root_buffer.ForceWriteInfo(tsi_tree, true);

    ofstream oft("test.bin", ios::binary);

    oft.write(root_buffer.Buffer(), root_buffer.BufferSize());
    oft.close();

		TFile f("test.root", "recreate");
		tree->Write();
		f.Close();
}
