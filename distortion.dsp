import("stdfaust.lib");

// Simulates soft clipping from tube amp
softClip = _ <: /(_, sqrt(1 + ^(_, 2)));

hardClip(ceiling) = min(hi) : max(lo)
with {
    hi = ceiling;
    lo = (-1) * ceiling;
};

// gain before hard clipping stage
fuzzGain = hslider("[0]fuzz gain", 1, 1, 10, 0.01) * 10 - 9 : ba.db2linear;
// gain before soft clipping stage
tubeGain = hslider("[1]tube gain", 1, 1, 10, 0.01) * 10 - 9 : ba.db2linear;
// gain after distortion
vol = hslider("[2]post-distortion gain (dB)", -10, -30, 0, 0.01) : ba.db2linear;

// The entire guitar amp
// (distortion + speaker)
amp =
    // LPF before hard clipping makes it less harsh
    fi.resonlp(3000, 1, 1)
    : *(fuzzGain)
    : hardClip(1)
    : *(tubeGain)
    : softClip
    : *(vol)
    : fi.dcblocker
    : ef.speakerbp(100, 5000);

feedback = hslider("[3]feedback (dB)", -50, -50, 0, 1) : ba.db2linear;
delay = hslider("[4]delay (ms)", 0, 0, 100, 0.1) : /(1000) : ba.sec2samp;

process = amp(+(_)) ~ (@(delay) : *(feedback));
//process = amp(os.osc(440));
