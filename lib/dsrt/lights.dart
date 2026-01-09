/// Lighting System API for DSRT Engine
/// 
/// Provides light sources, shadows, global illumination, and
/// lighting management for 3D scenes.
/// 
/// [includeGI]: Whether to include global illumination features.
/// Defaults to true.
library dsrt_engine.public.lights;

// Light Base Class
export '../src/lights/light.dart' 
    show Light, LightType, LightState;

// Directional Light
export '../src/lights/directional.dart' 
    show DirectionalLight, DirectionalParams;

// Point Light
export '../src/lights/point.dart' 
    show PointLight, PointParams, Attenuation;

// Spot Light
export '../src/lights/spot.dart' 
    show SpotLight, SpotParams, ConeAngle;

// Ambient Light
export '../src/lights/ambient.dart' 
    show AmbientLight, AmbientParams;

// Hemisphere Light
export '../src/lights/hemisphere.dart' 
    show HemisphereLight, SkyGroundColor;

// Rect Area Light
export '../src/lights/rect_area.dart' 
    show RectAreaLight, AreaDimensions;

// Light Shadow
export '../src/lights/light_shadow.dart' 
    show LightShadow, ShadowType, ShadowMap;

// Light Utilities
export '../src/lights/light_utils.dart' 
    show LightUtils, LightHelpers;

// Light Serialization
export '../src/lights/light_serializer.dart' 
    show LightSerializer, LightData;

// Light Validation
export '../src/lights/light_validator.dart' 
    show LightValidator, LightValidation;

// Light Manager
export '../src/lights/light_manager.dart' 
    show LightManager, LightingSystem;

// Light Baking
export '../src/lights/light_baker.dart' 
    show LightBaker, BakeSettings, Lightmap;

// Light Probe
export '../src/lights/light_probe.dart' 
    show LightProbe, ProbeData, Irradiance;

// IES Light (Photometric)
export '../src/lights/ies_light.dart' 
    show IESLight, IESProfile, PhotometricData;

// Portal Light
export '../src/lights/portal_light.dart' 
    show PortalLight, PortalGeometry, PortalOcclusion;

// Volume Light
export '../src/lights/volume_light.dart' 
    show VolumeLight, VolumeParams, Scattering;

// Lightmap System
export '../src/lights/lightmap.dart' 
    show Lightmap, LightmapUV, LightmapData;

// Global Illumination
export '../src/lights/global_illumination.dart' 
    show GlobalIllumination, GIMethod, Radiosity;

// Light Debugging
export '../src/lights/light_debug.dart' 
    show LightDebug, DebugVisualization, LightGizmo;
