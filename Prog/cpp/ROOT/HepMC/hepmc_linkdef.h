#include "HepMC/Flow.h"
#include "HepMC/GenCrossSection.h"
#include "HepMC/GenEvent.h"
#include "HepMC/GenParticle.h"
#include "HepMC/GenRanges.h"
#include "HepMC/GenVertex.h"
#include "HepMC/HeavyIon.h"
#include "HepMC/IO_AsciiParticles.h"
#include "HepMC/IO_BaseClass.h"
#include "HepMC/IO_Exception.h"
#include "HepMC/IO_GenEvent.h"
#include "HepMC/PdfInfo.h"
#include "HepMC/Polarization.h"
#include "HepMC/SimpleVector.h"
#include "HepMC/StreamInfo.h"
#include "HepMC/TempParticleMap.h"
#include "HepMC/WeightContainer.h"

using namespace HepMC;

#ifdef __CINT__
#pragma link off all globals;
#pragma link off all classes;
#pragma link off all functions;
//#pragma link C++ class std::runtime_error+;
#pragma link C++ class HepMC::ConstGenEventParticleRange+;
#pragma link C++ class HepMC::ConstGenEventVertexRange+;
#pragma link C++ class HepMC::ConstGenParticleEndRange+;
#pragma link C++ class HepMC::ConstGenParticleProductionRange+;
#pragma link C++ class HepMC::Flow+;
#pragma link C++ class HepMC::FourVector+;
#pragma link C++ class HepMC::GenCrossSection+;
#pragma link C++ class HepMC::GenEvent+;
#pragma link C++ class HepMC::GenEventParticleRange+;
#pragma link C++ class HepMC::GenEventVertexRange+;
#pragma link C++ class HepMC::GenParticle+;
#pragma link C++ class HepMC::GenParticleEndRange+;
#pragma link C++ class HepMC::GenParticleProductionRange+;
#pragma link C++ class HepMC::GenVertex+;
#pragma link C++ class HepMC::GenVertexParticleRange+;
#pragma link C++ class HepMC::HeavyIon+;
//#pragma link C++ class HepMC::HEPEVT_Wrapper+;
#pragma link C++ class HepMC::IO_AsciiParticles+;
#pragma link C++ class HepMC::IO_BaseClass+;
#pragma link C++ class HepMC::IO_Exception+;
#pragma link C++ class HepMC::IO_GenEvent+;
//#pragma link C++ class HepMC::IO_HEPEVT+;
//#pragma link C++ class HepMC::IO_HERWIG+;
#pragma link C++ class HepMC::PdfInfo+;
#pragma link C++ class HepMC::Polarization+;
#pragma link C++ class HepMC::StreamInfo+;
#pragma link C++ class HepMC::TempParticleMap+;
#pragma link C++ class HepMC::ThreeVector+;
#pragma link C++ class HepMC::WeightContainer+;
#endif
