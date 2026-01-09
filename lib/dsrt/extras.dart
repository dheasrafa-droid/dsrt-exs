/// Extra Components API for DSRT Engine
/// 
/// Provides debug helpers, procedural objects, particle systems,
/// and post-processors for enhanced graphics and debugging.
/// 
/// [includeParticles]: Whether to include particle system features.
/// Defaults to true.
library dsrt_engine.public.extras;

// Curve Mathematics
export '../src/extras/curves/curve.dart' 
    show Curve, ParametricCurve, ArcLength;

// Cubic Bezier Curve
export '../src/extras/curves/cubic_bezier.dart' 
    show CubicBezier, ControlPoints, Derivative;

// Quadratic Bezier Curve
export '../src/extras/curves/quadratic_bezier.dart' 
    show QuadraticBezier, QuadraticPoints;

// Spline Curve
export '../src/extras/curves/spline_curve.dart' 
    show SplineCurve, Knots, Continuity;

// Catmull-Rom Spline
export '../src/extras/curves/catmull_rom.dart' 
    show CatmullRom, TensionParameter;

// Ellipse Curve
export '../src/extras/curves/ellipse_curve.dart' 
    show EllipseCurve, EllipseParameters, Arc;

// Arc Curve
export '../src/extras/curves/arc_curve.dart' 
    show ArcCurve, CenterPoint, StartEndAngle;

// Line Curve
export '../src/extras/curves/line_curve.dart' 
    show LineCurve, Endpoints, LinearInterpolation;

// Curve Path
export '../src/extras/curves/curve_path.dart' 
    show CurvePath, SubCurves, GetPointAt;

// Curve Utilities
export '../src/extras/curves/curve_utils.dart' 
    show CurveUtils, LengthCalculation;

// Shape Path
export '../src/extras/paths/shape_path.dart' 
    show ShapePath, PathCommands, MoveTo;

// Font Path
export '../src/extras/paths/font_path.dart' 
    show FontPath, GlyphOutline, BezierContours;

// Path Utilities
export '../src/extras/paths/path_utils.dart' 
    show PathUtils, PathOperations;

// Path Serialization
export '../src/extras/paths/path_serializer.dart' 
    show PathSerializer, PathData;

// Axes Helper (Debug)
export '../src/extras/debug/axes_helper.dart' 
    show AxesHelper, AxisLength, Labels;

// Box Helper (Debug)
export '../src/extras/debug/box_helper.dart' 
    show BoxHelper, BoundingBox, Wireframe;

// Camera Helper (Debug)
export '../src/extras/debug/camera_helper.dart' 
    show CameraHelper, FrustumVisualization, ClippingPlanes;

// Directional Light Helper
export '../src/extras/debug/directional_light_helper.dart' 
    show DirectionalLightHelper, LightDirection, TargetLine;

// Hemisphere Light Helper
export '../src/extras/debug/hemisphere_light_helper.dart' 
    show HemisphereLightHelper, SkyColor, GroundColor;

// Plane Helper (Debug)
export '../src/extras/debug/plane_helper.dart' 
    show PlaneHelper, InfiniteGrid, NormalVector;

// Point Light Helper
export '../src/extras/debug/point_light_helper.dart' 
    show PointLightHelper, SphereHelper, RangeIndicator;

// Skeleton Helper
export '../src/extras/debug/skeleton_helper.dart' 
    show SkeletonHelper, BoneVisualization, JointSpheres;

// Spot Light Helper
export '../src/extras/debug/spot_light_helper.dart' 
    show SpotLightHelper, ConeVisualization, Penumbra;

// Polar Grid Helper
export '../src/extras/debug/polar_grid_helper.dart' 
    show PolarGridHelper, RadialLines, ConcentricCircles;

// Grid Helper (Cartesian)
export '../src/extras/debug/grid_helper.dart' 
    show GridHelper, GridSize, CellDivision;

// Arrow Helper (Vector)
export '../src/extras/debug/arrow_helper.dart' 
    show ArrowHelper, DirectionVector, HeadLength;

// Face Normals Helper
export '../src/extras/debug/face_normals_helper.dart' 
    show FaceNormalsHelper, NormalLength, FaceCentroid;

// Vertex Normals Helper
export '../src/extras/debug/vertex_normals_helper.dart' 
    show VertexNormalsHelper, VertexPosition, NormalDirection;

// Wireframe Helper
export '../src/extras/debug/wireframe_helper.dart' 
    show WireframeHelper, EdgeDetection, CreaseAngle;

// Helper Manager
export '../src/extras/debug/helper_manager.dart' 
    show HelperManager, DebugSystem;

// Reflector Object
export '../src/extras/objects/reflector.dart' 
    show Reflector, ReflectionPlane, RenderTexture;

// Refractor Object
export '../src/extras/objects/refractor.dart' 
    show Refractor, RefractionIndex, Distortion;

// Shadow Catcher
export '../src/extras/objects/shadow_catcher.dart' 
    show ShadowCatcher, AlphaMap, ReceiveShadow;

// Sky Object
export '../src/extras/objects/sky.dart' 
    show Sky, SkyModel, AtmosphericScattering;

// Water Object
export '../src/extras/objects/water.dart' 
    show Water, WaveParameters, Caustics;

// Terrain Object
export '../src/extras/objects/terrain.dart' 
    show Terrain, Heightmap, LODSystem;

// Clouds Object
export '../src/extras/objects/clouds.dart' 
    show Clouds, VolumetricClouds, NoiseLayers;

// Ocean Object
export '../src/extras/objects/ocean.dart' 
    show Ocean, FFTWater, GerstnerWaves;

// Vegetation System
export '../src/extras/objects/vegetation.dart' 
    show Vegetation, GrassSystem, TreeGenerator;

// Extra Object Manager
export '../src/extras/objects/extra_object_manager.dart' 
    show ExtraObjectManager, RegistrySystem;

// Particle System
export '../src/extras/particles/particle_system.dart' 
    show ParticleSystem, EmitterType, ParticlePool;

// Particle Emitter
export '../src/extras/particles/particle_emitter.dart' 
    show ParticleEmitter, BirthRate, Lifetime;

// Particle Physics
export '../src/extras/particles/particle_physics.dart' 
    show ParticlePhysics, Forces, Collisions;

// GPU Particles
export '../src/extras/particles/gpu_particles.dart' 
    show GPUParticles, ComputeShader, InstancedRendering;

// Trail Renderer
export '../src/extras/particles/trail_renderer.dart' 
    show TrailRenderer, TrailPoints, Decay;

// Particle Manager
export '../src/extras/particles/particle_manager.dart' 
    show ParticleManager, ParticleSystem;

// Outline Pass (Post-process)
export '../src/extras/postprocessors/outline_pass.dart' 
    show OutlinePass, EdgeDetection, SobelFilter;

// SSGI Pass (Screen Space Global Illumination)
export '../src/extras/postprocessors/ssgi_pass.dart' 
    show SSGIPass, IndirectLighting, RayMarching;

// TAA Pass (Temporal Anti-Aliasing)
export '../src/extras/postprocessors/taa_pass.dart' 
    show TAAPass, Jitter, HistoryBuffer;

// Motion Blur Pass
export '../src/extras/postprocessors/motion_blur_pass.dart' 
    show MotionBlurPass, VelocityBuffer, CameraMotion;

// Post-processor Manager
export '../src/extras/postprocessors/postprocessor_manager.dart' 
    show PostprocessorManager, EffectChain;
