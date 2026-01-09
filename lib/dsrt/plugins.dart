/// Plugin System API for DSRT Engine
/// 
/// Provides plugin architecture, VR/AR integration, physics backends,
/// and export plugins for extensibility.
/// 
/// [includeExperimental]: Whether to include experimental plugins.
/// Defaults to false.
library dsrt_engine.public.plugins;

// Plugin Manager
export '../src/plugins/plugin_manager.dart' 
    show PluginManager, Registry, LoadOrder;

// Plugin Utilities
export '../src/plugins/plugin_utils.dart' 
    show PluginUtils, LoaderHelpers;

// Plugin Serialization
export '../src/plugins/plugin_serializer.dart' 
    show PluginSerializer, Metadata;

// Plugin Validation
export '../src/plugins/plugin_validator.dart' 
    show PluginValidator, CompatibilityCheck;

// Plugin Configuration
export '../src/plugins/plugin_config.dart' 
    show PluginConfig, Settings;

// VR Plugin Manager
export '../src/plugins/vr/vr_manager.dart' 
    show VRManager, VRSystem, HMD;

// VR Controller
export '../src/plugins/vr/vr_controller.dart' 
    show VRController, InputSource, Pose;

// VR Display
export '../src/plugins/vr/vr_display.dart' 
    show VRDisplay, DisplayCapabilities, EyeParameters;

// VR Session
export '../src/plugins/vr/vr_session.dart' 
    show VRSession, SessionMode, ReferenceSpace;

// VR Utilities
export '../src/plugins/vr/vr_utils.dart' 
    show VRUtils, PoseHelpers;

// VR Configuration
export '../src/plugins/vr/vr_config.dart' 
    show VRConfig, RenderScale, MSAA;

// VR Debugging
export '../src/plugins/vr/vr_debug.dart' 
    show VRDebug, PerformanceHUD;

// AR Plugin Manager
export '../src/plugins/ar/ar_manager.dart' 
    show ARManager, ARSession, WorldTracking;

// AR Anchor
export '../src/plugins/ar/ar_anchor.dart' 
    show ARAnchor, AnchorType, TrackingState;

// AR Session Management
export '../src/plugins/ar/ar_session.dart' 
    show ARSession, Configuration, FeaturePoints;

// AR Hit Testing
export '../src/plugins/ar/ar_hit_test.dart' 
    show ARHitTest, RaycastQuery, ResultType;

// AR Plane Detection
export '../src/plugins/ar/ar_plane.dart' 
    show ARPlane, PlaneGeometry, Alignment;

// AR Utilities
export '../src/plugins/ar/ar_utils.dart' 
    show ARUtils, CameraHelpers;

// AR Configuration
export '../src/plugins/ar/ar_config.dart' 
    show ARConfig, TrackingQuality;

// AR Debugging
export '../src/plugins/ar/ar_debug.dart' 
    show ARDebug, Visualizations;

// XR Manager (Cross-reality)
export '../src/plugins/xr/xr_manager.dart' 
    show XRManager, XRSystem, SessionManager;

// XR Session
export '../src/plugins/xr/xr_session.dart' 
    show XRSession, XRFrame, AnimationFrame;

// XR Input System
export '../src/plugins/xr/xr_input.dart' 
    show XRInput, InputSource, Gamepad;

// XR Reference Space
export '../src/plugins/xr/xr_reference_space.dart' 
    show XRReferenceSpace, StageBounds, Viewer;

// XR Utilities
export '../src/plugins/xr/xr_utils.dart' 
    show XRUtils, FrameHelpers;

// XR Configuration
export '../src/plugins/xr/xr_config.dart' 
    show XRConfig, EnvironmentBlendMode;

// Ammo.js Physics Plugin
export '../src/plugins/physics_plugins/ammo_plugin.dart' 
    show AmmoPlugin, AmmoBinding, WASMLoader;

// Bullet Physics Plugin
export '../src/plugins/physics_plugins/bullet_plugin.dart' 
    show BulletPlugin, BulletWorld, NativeBinding;

// Cannon.js Physics Plugin
export '../src/plugins/physics_plugins/cannon_plugin.dart' 
    show CannonPlugin, CannonWorld, JSIntegration;

// PhysX Physics Plugin
export '../src/plugins/physics_plugins/physx_plugin.dart' 
    show PhysXPlugin, PhysXSDK, GPUAcceleration;

// Physics Plugin Manager
export '../src/plugins/physics_plugins/physics_plugin_manager.dart' 
    show PhysicsPluginManager, BackendSelector;

// GLTF Exporter Plugin
export '../src/plugins/export_plugins/gltf_exporter_plugin.dart' 
    show GLTFExporterPlugin, GLBWriter, JSONWriter;

// OBJ Exporter Plugin
export '../src/plugins/export_plugins/obj_exporter_plugin.dart' 
    show OBJExporterPlugin, WavefrontWriter, MTLWriter;

// STL Exporter Plugin
export '../src/plugins/export_plugins/stl_exporter_plugin.dart' 
    show STLExporterPlugin, BinarySTL, ASCIISTL;

// PLY Exporter Plugin
export '../src/plugins/export_plugins/ply_exporter_plugin.dart' 
    show PLYExporterPlugin, PointCloudExport, MeshExport;

// Exporter Plugin Manager
export '../src/plugins/export_plugins/exporter_plugin_manager.dart' 
    show ExporterPluginManager, FormatRegistry;
