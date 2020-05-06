import("stdfaust.lib");

// Show knob as 1-10 like a guitar amp but scale the actual value so that we
// get HIGH GAIN!
gain = hslider("gain", 1, 1, 10, 0.1) * 10;
vol = hslider("post-distortion volume", 0.3, 0, 1, 0.01);
shift = hslider("shift", 0, 0, 1, 0.01);

transferFunction = _ + shift <: /(vol * gain * _, sqrt(1 + gain * ^(gain * _, 2)));

// The entire guitar amp
// (distortion + speaker)
amp = transferFunction : ef.speakerbp(100, 5000);

feedback = hslider("feedback", 0.01, 0, 0.1, 0.001);
delay = hslider("delay (samples)", 1, 0, 100, 10);
process = amp(+(_)) ~ (@(delay) : *(feedback));
