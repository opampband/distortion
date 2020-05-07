import("stdfaust.lib");

// Simulates soft clipping from tube amp
transferFunction = \(x, dx, wobble).(
    x <: /(x, sqrt(1 + (1 - wobble * dx) * ^(x, 2)))
);

// Takes the derivative of a signal by convolution
derivative = fi.lowpass(1, 2000) : fi.conv((1, -1));

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
// how vertically asymmetrical the soft clipping stage is
// TODO wobble is disabled to avoid NaN
//wobble = hslider("wobble", 0, -10, 10, 0.01);
wobble = 0;
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
    : transferFunction(_, derivative(_), wobble)
    : *(vol)
    : ef.speakerbp(100, 5000);

feedback = hslider("feedback", 0.01, 0, 0.1, 0.001);
delay = hslider("delay (samples)", 1, 0, 100, 10);

process = amp(+(_)) ~ (@(delay) : *(feedback));
//process = amp(os.osc(440));
