# OP-AMP Distortion

A digital guitar distortion effect. Written in [Faust](https://faust.grame.fr/).

## Build Instructions

- Install Faust. See [https://faust.grame.fr/doc/manual/#the-faust-distribution].
- Install Jack and GTK development libraries. See [https://faust.grame.fr/doc/manual/#faust2jack] for details.
- `make` to compile the executable program (a jack client).
- `make run` to run the program.
- Do whatever Jack stuff you need to do to hook up the input and output of the client.

## TODO
- Add noise gate
- Add tone stack (bass, mid, treble, presence?)
- Experiment with uneven distortion across different frequency bands
- Add room reverb before feeding back to amp
  - Perhaps try to figure out what the impulse response of a sympathetically vibrating string would be
- Experiment with multiple gain stages
- Try to acheive more of a fuzz sound
  - Maybe look into modelling (non-linear) transistors
- Experiment with cabinet impulse responses
- Build in a plugin format (probably VST)
