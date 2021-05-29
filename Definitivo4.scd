//SOUND LIBRARY + TOUCH OSC


//LIBRARY


(
SynthDef(\kick, {
    |out = 0, pan = 0, panning=0, amp = 0.3, ampRev|
    var body, bodyFreq, bodyAmp;
    var pop, popFreq, popAmp;
    var click, clickAmp;
    var snd;

    // body starts midrange, quickly drops down to low freqs, and trails off
    bodyFreq = EnvGen.ar(Env([261, 120, 51], [0.035, 0.08], curve: \exp));
    bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3));
    body = SinOsc.ar(bodyFreq) * bodyAmp;
    // pop sweeps over the midrange
    popFreq = XLine.kr(750, 261, 0.02);
    popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
    pop = SinOsc.ar(popFreq) * popAmp;
    // click is spectrally rich, covering the high-freq range
    // you can use Formant, FM, noise, whatever
    clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
    click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

    snd = body + pop + click;
    snd = snd.tanh;

	snd = snd + FreeVerb.ar(snd, mix: 0.5, room: 0.9, mul: ampRev);


    Out.ar(out, Pan2.ar(snd, pan*panning, amp));
}).add;

SynthDef(\snare, {
    |out = 0, pan = -1, panning = 0, amp = 0.3, ampRev|
    var pop, popAmp, popFreq;
    var noise, noiseAmp;
    var snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
    // bandpass-filtered white noise
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.15));
    noise = BPF.ar(WhiteNoise.ar, 810, 1.6) * noiseAmp;

    snd = (pop + noise) * 1.3;

	snd = snd + FreeVerb.ar(snd, mix: 0.5, room: 0.9, mul: ampRev);



    Out.ar(out, Pan2.ar(snd, pan*panning, amp));
}).add;

SynthDef(\hihat, {
    |out = 0, pan = -0.8, panning = 0, amp = 0.3, ampRev|
    var click, clickAmp;
    var noise, noiseAmp;
    var snd;

    // noise -> resonance -> expodec envelope
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.3, curve: -8));
    noise = Mix(BPF.ar(ClipNoise.ar, [4010, 4151], [0.15, 0.56], [1.0, 0.6])) * 0.7 * noiseAmp;

    snd = noise;

	snd = snd + FreeVerb.ar(snd, mix: 0.5, room: 0.9, mul: ampRev);

    Out.ar(out, Pan2.ar(snd, pan*panning, amp));
}).add;

SynthDef(\tom1,
	{arg out = 0, sustain = 0.4, drum_mode_level = 0.25,
	freq = 90, drum_timbre = 1.0, amp = 0.8, panning = 0, ampRev, pan = -0.3;
	var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
	var stick_noise, stick_env;
	var drum_reson, tom_mix;
	var snd;

	drum_mode_env = EnvGen.ar(Env.perc(0.005, sustain), 1.0);
	drum_mode_sin_1 = SinOsc.ar(freq*0.8, 0, drum_mode_env * 0.5);
	drum_mode_sin_2 = SinOsc.ar(freq, 0, drum_mode_env * 0.5);
	drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.9),
								freq*0.85,
								drum_timbre/1.3,
								mul: drum_mode_env*5,
								add: 0);
	drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * drum_mode_level;
	stick_noise = Crackle.ar(2.01, 1);
	stick_env = EnvGen.ar(Env.perc(0.005, 0.01), 1.0) * 3;
	tom_mix = Mix.new([drum_mode_mix, stick_env]) * 4 * amp;
		snd = tom_mix ;
		snd = snd + FreeVerb.ar(snd, mix: 0.5, room: 0.9, mul: ampRev);
		Out.ar(out,Pan2.ar(snd, pan*panning, amp));
	}
).add;

SynthDef(\tom2,
	{arg out = 0, sustain = 0.4, drum_mode_level = 0.25,
	freq = 80, drum_timbre = 1.0, amp = 0.8, panning = 0, ampRev, pan = 0.3;
	var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
	var stick_noise, stick_env;
	var drum_reson, tom_mix;
	var snd;

	drum_mode_env = EnvGen.ar(Env.perc(0.005, sustain), 1.0);
	drum_mode_sin_1 = SinOsc.ar(freq*0.8, 0, drum_mode_env * 0.5);
	drum_mode_sin_2 = SinOsc.ar(freq, 0, drum_mode_env * 0.5);
	drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.9),
								freq*0.85,
								drum_timbre/1.3,
								mul: drum_mode_env*5,
								add: 0);
	drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * drum_mode_level;
	stick_noise = Crackle.ar(2.01, 1);
	stick_env = EnvGen.ar(Env.perc(0.005, 0.01), 1.0) * 3;
	tom_mix = Mix.new([drum_mode_mix, stick_env]) * 4 * amp;
	snd = tom_mix ;
		snd = snd + FreeVerb.ar(snd, mix: 0.5, room: 0.9, mul: ampRev);
		Out.ar(out,Pan2.ar(snd, pan*panning, amp));
	}
).add;

SynthDef(\floorTom,
	{arg out = 0, sustain = 0.4, drum_mode_level = 0.25,
		freq = 30, drum_timbre = 1.0, amp = 0.8, panning = 0, ampRev, pan = 1;
	var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
	var stick_noise, stick_env;
	var drum_reson, tom_mix;
	var snd;

	drum_mode_env = EnvGen.ar(Env.perc(0.005, sustain), 1.0);
	drum_mode_sin_1 = SinOsc.ar(freq*0.8, 0, drum_mode_env * 0.5);
	drum_mode_sin_2 = SinOsc.ar(freq, 0, drum_mode_env * 0.5);
	drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.9),
								freq*0.85,
								drum_timbre/1.3,
								mul: drum_mode_env*5,
								add: 0);
	drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * drum_mode_level;
	stick_noise = Crackle.ar(2.01, 1);
	stick_env = EnvGen.ar(Env.perc(0.005, 0.01), 1.0) * 3;
	tom_mix = Mix.new([drum_mode_mix, stick_env]) * 2 * amp;
	snd = tom_mix ;
		snd = snd + FreeVerb.ar(snd, mix: 0.5, room: 0.9, mul: ampRev);
		Out.ar(out,Pan2.ar(snd, pan*panning, amp));
	}
).add;


SynthDef(\crashCymbal, {
  arg amp = 1, panning = 0, ampRev, pan = -0.5;
  var snd;
  var whiteNoise = PinkNoise.ar(
    mul: Env.perc(releaseTime: 1, curve: -7).kr);
	snd = HPF.ar(whiteNoise, freq: 7040);
	snd = snd + FreeVerb.ar(snd, mix: 0.5, room: 0.9, mul: ampRev);
	Out.ar(0, Pan2.ar(snd, pan*panning, 4*amp));
}).add;


SynthDef(\rideCymbal, {
arg out=0, baseFreq = 300, time = 250, amp=0.1, ampRev, pan = 0.8, panning = 0;
var freqs = [205.35, 304.41, 369.64, 522.71, 540.54, 812.21];
var signal, pulseEnv, snd;

pulseEnv = EnvGen.ar(Env.new([1.0, 0.6], [time], [-0.5]), timeScale:(1/1000));
signal = Mix.new(LFPulse.ar(freqs * 4.09));
signal = (BinaryOpUGen('==', signal, 6.0) * 0.6) + (BinaryOpUGen('==', signal, 2.0) * 0.2) + (BinaryOpUGen('==', signal, 1.0) * 0.9);
 signal = (signal * pulseEnv) + (Mix.new(LFPulse.ar(freqs, width:0.55)) * 0.9);
signal = RLPF.ar(signal, 7000, 0.6);
signal = RHPF.ar(signal, 6800, 1.5);
signal = RHPF.ar(signal, 6800, 1.5);
signal = RHPF.ar(signal, 1200, 1.5);
signal = signal * EnvGen.ar(Env.new([0, 1, 0.4, 0, 0], [2, time, 50, 500], [0, -0.5, 0, -50]), timeScale:(1/1000));
signal = [signal, DelayN.ar(signal, 0.005, 0.005)];
snd = signal;
snd = snd + FreeVerb.ar(snd, mix: 0.5, room: 0.9, mul: ampRev);
OffsetOut.ar(out, Pan2.ar(snd, pan*panning, 4*amp));
}
).add;




)


//TOUCH OSC
OSCFunc.trace(false);

(
var snareGain = 0;
var kickGain = 0;
var hiHatGain = 0;
var floorTomGain = 0;
var tom1Gain = 0;
var tom2Gain = 0;
var crashCymbalGain = 0;
var rideCymbalGain = 0;

//Metronome
OSCdef(\getMetronomeBPM,
	{
		arg msg;
		~metronomeBPM = msg[1];

		postln("MetronomeBPM: "+ ~metronomeBPM);
	},
	"/metronomeSlider"

);

OSCdef(\getMetronomeSwitch,
	{
		arg msg;
		~metronomeSwitch = msg[1];

		postln("MetronomeSwitch: "+ ~metronomeSwitch);
	},
	"/metroToggle"

);

OSCdef(\getMasterGain,
	{
		arg msg;
		~gain_m = msg[1];

		postln("gain_m: "+ ~gain_m);
	},
	"/masterGain"

);


//masterGain
OSCdef(\getMasterRev,
	{
		arg msg;
		~rev = msg[1];

		postln("rev: "+ ~rev);
	},
	"/reverb"

);

//masterPan
OSCdef(\getMasterPan,
	{
		arg msg;
		~panning = msg[1];

		postln("pan: "+ ~panning);
	},
	"/panning"

);

//Snare
OSCdef(\getSnareGain,
	{
		arg msg;
		snareGain = msg[1];

		postln("snare gain: "+ snareGain);
	},
	"/snareGain"

);


OSCdef(\getSnare,
	{
		arg msg;
		x = msg[1];

		s = Synth.tail(nil, \snare, [\amp, ~gain_m*snareGain, \panning, ~panning, \ampRev, ~rev]);

		postln("snare: "+ x);
	},
	"/snare"

);

//Kick
OSCdef(\getKickGain,
	{
		arg msg;
		kickGain = msg[1];

		postln("kick gain: "+ kickGain);
	},
	"/kickGain"

);


OSCdef(\getKick,
	{
		arg msg;
		x = msg[1];

		s = Synth.tail(nil, \kick, [\amp, ~gain_m*kickGain, \panning, ~panning, \ampRev, ~rev]);


		postln("kick: "+ x);
	},
	"/kick"

);

//HiHat
OSCdef(\getHiHatGain,
	{
		arg msg;
		hiHatGain = msg[1];

		postln("hiHat gain: "+ hiHatGain);
	},
	"/hiHatGain"

);
OSCdef(\getHihat,
	{
		arg msg;
		x = msg[1];

		s = Synth.tail(nil, \hihat, [\amp, ~gain_m*hiHatGain, \panning, ~panning, \ampRev, ~rev]);

		postln("hihat: "+ x);
	},
	"/hiHat"

);

//Tom1
OSCdef(\getTom1Gain,
	{
		arg msg;
		tom1Gain = msg[1];

		postln("tom1 gain: "+ tom1Gain);
	},
	"/tom1Gain"

);


OSCdef(\getTom1,
	{
		arg msg;
		x = msg[1];

		s = Synth.tail(nil, \tom1, [\amp, ~gain_m*tom1Gain, \panning, ~panning, \ampRev, ~rev]);

		postln("tom1: "+ x);
	},
	"/tom1"

);

//Tom2
OSCdef(\getTom2Gain,
	{
		arg msg;
		tom2Gain = msg[1];

		postln("tom2 gain: "+ tom2Gain);
	},
	"/tom1Gain"

);


OSCdef(\getTom2,
	{
		arg msg;
		x = msg[1];

		s = Synth.tail(nil, \tom2, [\amp, ~gain_m*tom2Gain, \panning, ~panning, \ampRev, ~rev]);

		postln("tom2: "+ x);
	},
	"/tom2"

);

//FloorTom
OSCdef(\getfloorTomGain,
	{
		arg msg;
		floorTomGain = msg[1];

		postln("FloorTom gain: "+ floorTomGain);
	},
	"/floorTomGain"

);


OSCdef(\getFloorTom,
	{
		arg msg;
		x = msg[1];

		s = Synth.tail(nil, \floorTom, [\amp, ~gain_m*floorTomGain, \panning, ~panning, \ampRev, ~rev]);

		postln("FloorTom: "+ x);
	},
	"/floorTom"

);

//CrashCymbal
OSCdef(\getCrashCymbalGain,
	{
		arg msg;
		crashCymbalGain = msg[1];

		postln("CrashCymbal gain: "+ crashCymbalGain);
	},
	"/crashCymbalGain"

);


OSCdef(\getCrashCymbal,
	{
		arg msg;
		x = msg[1];

		s = Synth.tail(nil, \crashCymbal, [\amp, ~gain_m*crashCymbalGain, \panning, ~panning, \ampRev, ~rev]);

		postln("CrashCymbal: "+ x);
	},
	"/crashCymbal"

);

//RideCymbal
OSCdef(\getRideCymbalGain,
	{
		arg msg;
		rideCymbalGain = msg[1];

		postln("RideCymbal gain: "+ rideCymbalGain);
	},
	"/rideCymbalGain"

);


OSCdef(\getRideCymbal,
	{
		arg msg;
		x = msg[1];

		s = Synth.tail(nil, \rideCymbal, [\amp, ~gain_m*rideCymbalGain, \panning, ~panning, \ampRev, ~rev]);

		postln("RideCymbal: "+ x);
	},
	"/rideCymbal"

);


)
