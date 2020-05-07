import("stdfaust.lib");


process = os.oscsin(1 / ba.samp2sec(5)),
    (os.oscsin(1 / ba.samp2sec(5)) : fi.conv((1, -1)));
