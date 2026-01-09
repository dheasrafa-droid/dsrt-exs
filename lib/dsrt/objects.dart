/// 3D Objects API for DSRT Engine
/// 
/// Provides mesh, line, point, and specialized 3D object types
/// for scene composition and rendering.
/// 
/// [includeSkinned]: Whether to include skinned mesh features.
/// Defaults to true.
library dsrt_engine.public.objects;

// Mesh Object
export '../src/objects/mesh.dart' 
    show Mesh, MeshType, MeshState;

// Line Object
export '../src/objects/line.dart' 
    show Line, LineType, LineMode;

// Points Object
export '../src/objects/points.dart' 
    show Points, PointsType, PointsMode;

// Sprite Object
export '../src/objects/sprite.dart' 
    show Sprite, BillboardType;

// Skinned Mesh
export '../src/objects/skinned_mesh.dart' 
    show SkinnedMesh, SkinType, Skeleton;

// Instanced Mesh
export '../src/objects/instanced_mesh.dart' 
    show InstancedMesh, InstanceCount, InstanceData;

// Object Utilities
export '../src/objects/object_utils.dart' 
    show ObjectUtils, ObjectHelpers;

// Object Serialization
export '../src/objects/object_serializer.dart' 
    show ObjectSerializer, SerializationFormat;

// Object Validation
export '../src/objects/object_validator.dart' 
    show ObjectValidator, ValidationRules;

// Object Factory
export '../src/objects/object_factory.dart' 
    show ObjectFactory, FactoryPreset;

// Object Manager
export '../src/objects/object_manager.dart' 
    show ObjectManager, RegistrySystem;

// Bone Object
export '../src/objects/bone.dart' 
    show Bone, BoneType, BoneConstraint;

// Skeleton System
export '../src/objects/skeleton.dart' 
    show Skeleton, Joint, Pose;

// Morph Target
export '../src/objects/morph_target.dart' 
    show MorphTarget, MorphWeight, MorphAnimation;

// Ribbon Object
export '../src/objects/ribbon.dart' 
    show Ribbon, RibbonWidth, RibbonTrail;

// Tube Object
export '../src/objects/tube.dart' 
    show Tube, TubePath, TubeSection;

// Video Object
export '../src/objects/video_object.dart' 
    show VideoObject, VideoSource, VideoPlayback;

// Canvas Object
export '../src/objects/canvas_object.dart' 
    show CanvasObject, CanvasSource, CanvasUpdate;

// Lens Flare
export '../src/objects/lens_flare.dart' 
    show LensFlare, FlareElement, FlareSystem;

// Skybox Object
export '../src/objects/skybox.dart' 
    show Skybox, SkyboxType, SkyMaterial;

// Reflection Probe
export '../src/objects/reflection_probe.dart' 
    show ReflectionProbe, ProbeType, CaptureSettings;

// Light Probe
export '../src/objects/light_probe.dart' 
    show LightProbe, ProbeData, SphericalHarmonics;

// Environment Probe
export '../src/objects/environment_probe.dart' 
    show EnvironmentProbe, EnvironmentCapture;

// Decal Object
export '../src/objects/decal.dart' 
    show Decal, DecalProjection, DecalMaterial;

// Billboard Object
export '../src/objects/billboard.dart' 
    show Billboard, BillboardMode, Alignment;

// Impostor Object (LOD)
export '../src/objects/impostor.dart' 
    show Impostor, ImpostorType, QualityLevel;
