import("stdfaust.lib");

// Simulates soft clipping from tube amp
softClip = _ <: /(_, sqrt(1 + ^(_, 2)));

hardClip(ceiling) = min(hi) : max(lo)
with {
    hi = ceiling;
    lo = (-1) * ceiling;
};

// gain before any effects
inputGain = hslider("input gain", 1, 1, 10, 0.01) * 10 - 9;
// gain before hard clipping stage
fuzzGain = hslider("fuzz gain", 1, 1, 10, 0.01) * 10 - 9;
// gain before soft clipping stage
tubeGain = hslider("tube gain", 1, 1, 10, 0.01) * 20 - 19;
// volume after distortion
vol = hslider("post-distortion volume", 0.1, 0, 1, 0.01);

// The entire guitar amp
// (distortion + speaker)
amp =
    *(inputGain)
    // LPF before hard clipping makes it less harsh
    : fi.resonlp(3000, 1, 1)
    : *(fuzzGain)
    : hardClip(1)
    : *(tubeGain)
    : softClip
    : *(vol)
    : fi.dcblocker
    : ef.speakerbp(100, 5000);

feedback = hslider("feedback", 0.01, 0, 0.1, 0.001);
delay = hslider("delay (samples)", 1, 0, 100, 10);

process = amp(+(_)) ~ (@(delay) : *(feedback));
//process = amp(os.osc(440));
