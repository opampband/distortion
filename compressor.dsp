import("stdfaust.lib");

gate_thresh = hslider("[0]gate thresh (dB)", -100, -100, 0, 1);
// _ : gate_mono(gate_thresh,att,hold,rel) : _
gate = ef.gate_mono(thresh, 0.0001, 0.1, 0.02);

ratio = hslider("[1]ratio", 1, 1, 10, 0.1);
thresh = hslider("[2]thresh (dB)", 1, -40, 1, 0.1);

gain = hslider("[3]gain", 0, -30, 30, 0.1) : ba.db2linear;

process = 
    gate
    : co.compressor_mono(ratio, thresh, 1/1000, 1/1000)
    : *(gain);
