/// Camera System API for DSRT Engine
/// 
/// Provides camera types, projections, controls, and cinematic features
/// for 3D viewing and rendering.
/// 
/// [includeControls]: Whether to include camera control systems.
/// Defaults to true.
library dsrt_engine.public.camera;

// Camera Base Class
export '../src/camera/camera.dart' 
    show Camera, CameraType, CameraState;

// Perspective Camera
export '../src/camera/perspective.dart' 
    show PerspectiveCamera, PerspectiveParams;

// Orthographic Camera
export '../src/camera/orthographic.dart' 
    show OrthographicCamera, OrthographicParams;

// Camera Utilities
export '../src/camera/camera_utils.dart' 
    show CameraUtils, CameraHelpers;

// Camera Serialization
export '../src/camera/camera_serializer.dart' 
    show CameraSerializer, CameraData;

// Camera Validation
export '../src/camera/camera_validator.dart' 
    show CameraValidator, CameraValidation;

// Camera Frustum
export '../src/camera/camera_frustum.dart' 
    show CameraFrustum, FrustumCorners;

// Camera Projection
export '../src/camera/camera_projection.dart' 
    show CameraProjection, ProjectionMatrix;

// Camera Viewport
export '../src/camera/camera_viewport.dart' 
    show CameraViewport, ViewportRect;

// Array Camera (Multi-view)
export '../src/camera/array_camera.dart' 
    show ArrayCamera, CameraArray;

// Stereo Camera (VR/3D)
export '../src/camera/stereo_camera.dart' 
    show StereoCamera, StereoParams;

// Cube Camera (Environment Maps)
export '../src/camera/cube_camera.dart' 
    show CubeCamera, CubeFace;

// Cinematic Camera
export '../src/camera/cinematic_camera.dart' 
    show CinematicCamera, CameraShot;

// Cinematic Lens Effects
export '../src/camera/cinematic_lens.dart' 
    show CinematicLens, LensEffect;

// Depth of Field
export '../src/camera/depth_of_field.dart' 
    show DepthOfField, DOFParams;

// Motion Blur
export '../src/camera/motion_blur.dart' 
    show MotionBlur, MotionBlurParams;

// Control Base Class
export '../src/camera/controls/control_base.dart' 
    show ControlBase, ControlState;

// Orbit Controls
export '../src/camera/controls/orbit_controls.dart' 
    show OrbitControls, OrbitParams;

// Fly Controls
export '../src/camera/controls/fly_controls.dart' 
    show FlyControls, FlyParams;

// First Person Controls
export '../src/camera/controls/first_person_controls.dart' 
    show FirstPersonControls, FPSParams;

// Trackball Controls
export '../src/camera/controls/trackball_controls.dart' 
    show TrackballControls, TrackballParams;

// Pointer Lock Controls
export '../src/camera/controls/pointer_lock_controls.dart' 
    show PointerLockControls, PointerLockParams;

// Device Orientation Controls
export '../src/camera/controls/device_orientation_controls.dart' 
    show DeviceOrientationControls, OrientationParams;

// VR Controls
export '../src/camera/controls/vr_controls.dart' 
    show VRControls, VRController;

// AR Controls
export '../src/camera/controls/ar_controls.dart' 
    show ARControls, ARSession;

// Editor Controls
export '../src/camera/controls/editor_controls.dart' 
    show EditorControls, EditorParams;

// Camera Rig (Multi-camera setup)
export '../src/camera/controls/camera_rig.dart' 
    show CameraRig, RigType;

// Control Utilities
export '../src/camera/controls/control_utils.dart' 
    show ControlUtils, ControlHelpers;

// Control Manager
export '../src/camera/controls/control_manager.dart' 
    show ControlManager, ControlMapping;
