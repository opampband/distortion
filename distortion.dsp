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

//fb1 = hslider("fb1", 0.5, 0, 1, 0.1);
//fb2 = hslider("fb2", 0.5, 0, 1, 0.1);
//damp = hslider("fb2", 0.5, 0, 1, 0.1);
//reverb = _ <: _ * mix, (1 - mix) * re.mono_freeverb(fb1, fb2, damp, 0) :> _;
//reverb = _ <: _ * mix, (re.satrev :> *(1 - mix)) :> _;
reverb = _ <: (1 - mix) * _, mix * wet :> _
with {
    mix = hslider("mix", 0, 0, 1, 0.1);

    time = hslider("time", 0, 0, 20, 0.01);

    rdel = 1;
    f1 = 200;
    f2 = 6000;
    t60dc = time;
    t60m = time;
    fsmax = 48000;
    wet = _ <: re.zita_rev1_stereo(rdel, f1, f2, t60dc, t60m, fsmax) :> _;
};

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

res = hslider("resonance", 500, 50, 10000, 1);
process = (amp(+(_)) : reverb) ~ (@(delay) : fi.resonbp(res, 1, 1) : *(feedback));
//process = amp(os.osc(440));
