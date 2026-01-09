/// Animation System API for DSRT Engine
/// 
/// Provides keyframe animation, skeletal animation, blending,
/// and animation control for 3D objects and characters.
/// 
/// [includeSkeletal]: Whether to include skeletal animation features.
/// Defaults to true.
library dsrt_engine.public.animation;

// Animation Clip
export '../src/animation/animation_clip.dart' 
    show AnimationClip, ClipType, ClipData;

// Animation Mixer
export '../src/animation/animation_mixer.dart' 
    show AnimationMixer, MixerState, BlendTree;

// Animation Action
export '../src/animation/animation_action.dart' 
    show AnimationAction, ActionState, PlaybackControl;

// Keyframe Track
export '../src/animation/keyframe_track.dart' 
    show KeyframeTrack, TrackType, KeyframeData;

// Property Binding
export '../src/animation/property_binding.dart' 
    show PropertyBinding, BindingType, TargetPath;

// Animation Utilities
export '../src/animation/animation_utils.dart' 
    show AnimationUtils, AnimationHelpers;

// Animation Serialization
export '../src/animation/animation_serializer.dart' 
    show AnimationSerializer, AnimationData;

// Animation Validation
export '../src/animation/animation_validator.dart' 
    show AnimationValidator, AnimationValidation;

// Animation Manager
export '../src/animation/animation_manager.dart' 
    show AnimationManager, Timeline;

// Animation Player
export '../src/animation/animation_player.dart' 
    show AnimationPlayer, PlayerState, PlaybackOptions;

// Animation Controller
export '../src/animation/animation_controller.dart' 
    show AnimationController, ControllerState, StateMachine;

// Animation Blending
export '../src/animation/animation_blender.dart' 
    show AnimationBlender, BlendMode, BlendWeight;

// Animation Export
export '../src/animation/animation_exporter.dart' 
    show AnimationExporter, ExportFormat;

// Animation Import
export '../src/animation/animation_importer.dart' 
    show AnimationImporter, ImportFormat;

// Animation Debugging
export '../src/animation/animation_debug.dart' 
    show AnimationDebug, DebugVisualization;

// Boolean Track
export '../src/animation/tracks/boolean_track.dart' 
    show BooleanTrack, BoolKeyframe;

// Color Track
export '../src/animation/tracks/color_track.dart' 
    show ColorTrack, ColorKeyframe;

// Number Track
export '../src/animation/tracks/number_track.dart' 
    show NumberTrack, NumberKeyframe;

// Quaternion Track
export '../src/animation/tracks/quaternion_track.dart' 
    show QuaternionTrack, QuatKeyframe;

// String Track
export '../src/animation/tracks/string_track.dart' 
    show StringTrack, StringKeyframe;

// Vector Track
export '../src/animation/tracks/vector_track.dart' 
    show VectorTrack, VectorKeyframe;

// Track Utilities
export '../src/animation/tracks/track_utils.dart' 
    show TrackUtils, TrackOperations;

// Track Serialization
export '../src/animation/tracks/track_serializer.dart' 
    show TrackSerializer, TrackData;

// Track Validation
export '../src/animation/tracks/track_validator.dart' 
    show TrackValidator, TrackValidation;

// Linear Interpolant
export '../src/animation/interpolants/linear_interpolant.dart' 
    show LinearInterpolant, LerpFunction;

// Cubic Interpolant
export '../src/animation/interpolants/cubic_interpolant.dart' 
    show CubicInterpolant, CubicFunction;

// Discrete Interpolant
export '../src/animation/interpolants/discrete_interpolant.dart' 
    show DiscreteInterpolant, StepFunction;

// Quaternion Linear Interpolant
export '../src/animation/interpolants/quaternion_linear_interpolant.dart' 
    show QuaternionLinearInterpolant, SlerpFunction;

// Spline Interpolant
export '../src/animation/interpolants/spline_interpolant.dart' 
    show SplineInterpolant, SplineFunction;

// Interpolant Manager
export '../src/animation/interpolants/interpolant_manager.dart' 
    show InterpolantManager, InterpolationSystem;

// Additive Blending
export '../src/animation/blending/additive_blending.dart' 
    show AdditiveBlending, AdditiveLayer;

// Crossfade Blending
export '../src/animation/blending/crossfade_blending.dart' 
    show CrossfadeBlending, CrossfadeTransition;

// Cumulative Blending
export '../src/animation/blending/cumulative_blending.dart' 
    show CumulativeBlending, CumulativeLayer;

// Blending Utilities
export '../src/animation/blending/blending_utils.dart' 
    show BlendingUtils, BlendOperations;

// Blending Manager
export '../src/animation/blending/blending_manager.dart' 
    show BlendingManager, BlendSystem;

// Animation Curve Base
export '../src/animation/curves/animation_curve.dart' 
    show AnimationCurve, CurveType, EasingFunction;

// Bezier Curve
export '../src/animation/curves/bezier_curve.dart' 
    show BezierCurve, BezierHandle, ControlPoint;

// Hermite Curve
export '../src/animation/curves/hermite_curve.dart' 
    show HermiteCurve, HermiteTangent, Tension;

// Catmull-Rom Curve
export '../src/animation/curves/catmull_rom_curve.dart' 
    show CatmullRomCurve, CatmullPoint, AlphaValue;

// Curve Manager
export '../src/animation/curves/curve_manager.dart' 
    show CurveManager, CurveLibrary;
