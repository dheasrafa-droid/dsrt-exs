/// Audio Engine API for DSRT Engine
/// 
/// Provides audio playback, spatial audio, effects, and mixing
/// for game sound and music.
/// 
/// [includeSpatial]: Whether to include spatial audio features.
/// Defaults to true.
library dsrt_engine.public.audio;

// Audio Context
export '../src/audio/audio_context.dart' 
    show AudioContext, ContextState, SampleRate;

// Audio Listener
export '../src/audio/audio_listener.dart' 
    show AudioListener, ListenerPosition, Orientation;

// Audio Source
export '../src/audio/audio_source.dart' 
    show AudioSource, SourceType, PlaybackState;

// Positional Audio
export '../src/audio/positional_audio.dart' 
    show PositionalAudio, Spatialization, DistanceModel;

// Audio Buffer
export '../src/audio/audio_buffer.dart' 
    show AudioBuffer, BufferData, DecodedAudio;

// Audio Analyser
export '../src/audio/audio_analyser.dart' 
    show AudioAnalyser, FrequencyData, Waveform;

// Audio Utilities
export '../src/audio/audio_utils.dart' 
    show AudioUtils, AudioHelpers;

// Audio Serialization
export '../src/audio/audio_serializer.dart' 
    show AudioSerializer, AudioData;

// Audio Validation
export '../src/audio/audio_validator.dart' 
    show AudioValidator, AudioValidation;

// Audio Manager
export '../src/audio/audio_manager.dart' 
    show AudioManager, MixingSystem;

// Audio Configuration
export '../src/audio/audio_config.dart' 
    show AudioConfig, OutputSettings;

// Audio Debugging
export '../src/audio/audio_debug.dart' 
    show AudioDebug, Visualization;

// Spatial Audio System
export '../src/audio/spatial/spatial_audio.dart' 
    show SpatialAudio, HRTF, DopplerEffect;

// HRTF Panner
export '../src/audio/spatial/hrtf_panner.dart' 
    show HRTFPanner, HeadModel, ImpulseResponse;

// Spatial Utilities
export '../src/audio/spatial/spatial_utils.dart' 
    show SpatialUtils, SpatialHelpers;

// Spatial Manager
export '../src/audio/spatial/spatial_manager.dart' 
    show SpatialManager, SpatializationSystem;

// Gain Node (Volume Control)
export '../src/audio/effects/gain_node.dart' 
    show GainNode, GainControl, Automation;

// Panner Node (Stereo/Spatial)
export '../src/audio/effects/panner_node.dart' 
    show PannerNode, PanningModel, Position;

// Filter Node (EQ)
export '../src/audio/effects/filter_node.dart' 
    show FilterNode, FilterType, FrequencyResponse;

// Delay Node (Echo/Reverb)
export '../src/audio/effects/delay_node.dart' 
    show DelayNode, DelayTime, Feedback;

// Convolver Node (Reverb)
export '../src/audio/effects/convolver_node.dart' 
    show ConvolverNode, ImpulseResponse, Convolution;

// Compressor Node (Dynamic Range)
export '../src/audio/effects/compressor_node.dart' 
    show CompressorNode, CompressionParams, Threshold;

// Analyser Node (Visualization)
export '../src/audio/effects/analyser_node.dart' 
    show AnalyserNode, FFT, TimeDomain;

// Oscillator Node (Synthesis)
export '../src/audio/effects/oscillator_node.dart' 
    show OscillatorNode, WaveType, Frequency;

// Buffer Source Node (Playback)
export '../src/audio/effects/buffer_source_node.dart' 
    show BufferSourceNode, PlaybackRate, LoopPoints;

// Media Element Source
export '../src/audio/effects/media_element_source_node.dart' 
    show MediaElementSourceNode, HTMLAudio, Streaming;

// Media Stream Source
export '../src/audio/effects/media_stream_source_node.dart' 
    show MediaStreamSourceNode, Microphone, WebRTC;

// Effect Utilities
export '../src/audio/effects/effect_utils.dart' 
    show EffectUtils, EffectHelpers;

// Effect Manager
export '../src/audio/effects/effect_manager.dart' 
    show EffectManager, EffectsChain;
