import("stdfaust.lib");

transferFunction = \(x, dx, wobble, gain).(
    // The gain here -----------------------------v makes it sound better
    x <: /(gain * x, sqrt(1 + (1 - wobble * dx) * gain * ^(gain * x, 2)))
);

// Takes the derivative of a signal by convolution
derivative = fi.lowpass(1, 2000) : fi.conv((1, -1));

// Show knob as 1-10 like a guitar amp but scale the actual value so that we
// get HIGH GAIN!
gain = hslider("gain", 1, 0, 10, 0.1) * 10;
vol = hslider("post-distortion volume", 0.3, 0, 1, 0.01);
wobble = hslider("wobble", 0, -10, 10, 0.01);

// The entire guitar amp
// (distortion + speaker)
amp = transferFunction(_, derivative(_), wobble, gain)
    : *(vol)
    : ef.speakerbp(100, 5000);

feedback = hslider("feedback", 0.01, 0, 0.1, 0.001);
delay = hslider("delay (samples)", 1, 0, 100, 10);

process = amp(+(_)) ~ (@(delay) : *(feedback));
//process = amp(os.osc(440));
