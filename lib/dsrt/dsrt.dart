/// Complete public API bundle for DSRT Engine
/// 
/// This file exports all public-facing APIs. For optimal tree-shaking,
/// import individual module files instead of this bundle.
/// 
/// [loadOptional]: Whether to load optional modules like VR/AR plugins.
/// Defaults to false.
library dsrt_engine.public_api;

// Core Engine Systems
export 'core.dart';

// Mathematics Library
export 'math.dart';

// 3D Scene Graph
export 'scene.dart';

// Camera Systems
export 'camera.dart';

// Geometry Processing
export 'geometry.dart';

// Material System
export 'materials.dart';

// Rendering Pipeline
export 'renderer.dart';

// 3D Objects
export 'objects.dart';

// Lighting System
export 'lights.dart';

// Texture Management
export 'textures.dart';

// Asset Loading
export 'loaders.dart';

// Animation System
export 'animation.dart';

// Physics Simulation
export 'physics.dart';

// Audio Engine
export 'audio.dart';

// User Interface
export 'ui.dart';

// Plugin System
export 'plugins.dart';

// Extra Components
export 'extras.dart';

// Development Tools
export 'tools.dart';

// Engine Constants
export 'constants.dart';

// Type Definitions
export 'types.dart';

// Enumerations
export 'enums.dart';

// Public Interfaces
export 'interfaces.dart';

// Alternative Exports (for advanced use)
export 'exports.dart';
