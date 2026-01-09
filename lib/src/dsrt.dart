/// DSRT Engine - Core facade exporting all public APIs
/// 
/// This file provides a single import point for all engine functionality.
/// Internal implementation details are hidden in src/ directory.
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

library dsrt_engine;

// Core systems
export 'core.dart' show ExsEngine, ExsEngineConfig, ExsGameLoop, ExsEventSystem;

// Math library
export 'math.dart' show ExsVec2, ExsVec3, ExsVec4, ExsMat3, ExsMat4, ExsQuaternion;

// Scene graph
export 'scene.dart' show ExsScene, ExsObject3D, ExsGroup;

// Camera system
export 'camera.dart' show ExsCamera, ExsPerspectiveCamera, ExsOrthographicCamera;

// Geometry
export 'geometry.dart' show ExsGeometry, ExsBufferGeometry, ExsBoxGeometry;

// Materials
export 'materials.dart' show ExsMaterial, ExsBasicMaterial, ExsStandardMaterial;

// Renderer
export 'renderer.dart' show ExsRenderer, ExsWebGLRenderer;

// 3D Objects
export 'objects.dart' show ExsMesh, ExsLine, ExsPoints;

// Lights
export 'lights.dart' show ExsLight, ExsDirectionalLight, ExsPointLight;

// Textures
export 'textures.dart' show ExsTexture, ExsImageTexture;

// Loaders
export 'loaders.dart' show ExsLoader, ExsImageLoader;

// Animation
export 'animation.dart' show ExsAnimationClip, ExsAnimationMixer;

// Physics (optional module)
export 'physics.dart' show ExsPhysicsWorld, ExsRigidBody;

// Audio (optional module)
export 'audio.dart' show ExsAudioContext, ExsAudioSource;

// UI (optional module)
export 'ui.dart' show ExsUIManager, ExsUIElement;

// Version information
export '../src/core/version.dart' show ExsVersion;
