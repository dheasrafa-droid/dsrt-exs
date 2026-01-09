/// Asset Loading API for DSRT Engine
/// 
/// Provides file loading, format parsing, and asset management
/// for 3D models, textures, audio, and other resources.
/// 
/// [includeGLTF]: Whether to include GLTF/GLB loader.
/// Defaults to true.
library dsrt_engine.public.loaders;

// Loader Base Class
export '../src/loaders/loader.dart' 
    show Loader, LoaderType, LoaderState;

// Loading Manager
export '../src/loaders/loading_manager.dart' 
    show LoadingManager, LoadQueue, ProgressTracker;

// File Loader
export '../src/loaders/file_loader.dart' 
    show FileLoader, FileType, LoadOptions;

// Image Loader
export '../src/loaders/image_loader.dart' 
    show ImageLoader, ImageFormat, DecodeOptions;

// GLTF Loader
export '../src/loaders/gltf_loader.dart' 
    show GLTFLoader, GLTFOptions, GLTFAsset;

// OBJ Loader
export '../src/loaders/obj_loader.dart' 
    show OBJLoader, OBJOptions, WavefrontOBJ;

// FBX Loader
export '../src/loaders/fbx_loader.dart' 
    show FBXLoader, FBXOptions, FBXScene;

// JSON Loader
export '../src/loaders/json_loader.dart' 
    show JSONLoader, JSONOptions, SceneJSON;

// Font Loader
export '../src/loaders/font_loader.dart' 
    show FontLoader, FontFormat, GlyphData;

// Audio Loader
export '../src/loaders/audio_loader.dart' 
    show AudioLoader, AudioFormat, DecodeAudio;

// Loader Utilities
export '../src/loaders/loader_utils.dart' 
    show LoaderUtils, LoaderHelpers;

// Loader Serialization
export '../src/loaders/loader_serializer.dart' 
    show LoaderSerializer, LoaderData;

// Loader Validation
export '../src/loaders/loader_validator.dart' 
    show LoaderValidator, LoaderValidation;

// Loader Manager
export '../src/loaders/loader_manager.dart' 
    show LoaderManager, ManagerConfig;

// Loader Cache
export '../src/loaders/loader_cache.dart' 
    show LoaderCache, CacheSystem;

// Loader Progress Tracking
export '../src/loaders/loader_progress.dart' 
    show LoaderProgress, ProgressEvent;

// Loader Error Handling
export '../src/loaders/loader_error.dart' 
    show LoaderError, ErrorType, ErrorRecovery;

// AMF Loader (Additive Manufacturing)
export '../src/loaders/amf_loader.dart' 
    show AMFLoader, AMFOptions, AMFModel;

// Collada Loader
export '../src/loaders/collada_loader.dart' 
    show ColladaLoader, ColladaOptions, DAEFormat;

// Draco Loader (Compressed Geometry)
export '../src/loaders/draco_loader.dart' 
    show DracoLoader, DracoOptions, CompressionLevel;

// KMZ Loader (Google Earth)
export '../src/loaders/kmz_loader.dart' 
    show KMZLoader, KMZOptions, KMLData;

// MD2 Loader (Quake 2 Model)
export '../src/loaders/md2_loader.dart' 
    show MD2Loader, MD2Options, QuakeModel;

// PCD Loader (Point Cloud)
export '../src/loaders/pcd_loader.dart' 
    show PCDLoader, PCDOptions, PointCloudData;

// PDB Loader (Protein Data Bank)
export '../src/loaders/pdb_loader.dart' 
    show PDBLoader, PDBOptions, MolecularData;

// PRWM Loader (Progressive Mesh)
export '../src/loaders/prwm_loader.dart' 
    show PRWMLoader, PRWMOptions, ProgressiveMesh;

// STL Loader (Stereolithography)
export '../src/loaders/stl_loader.dart' 
    show STLLoader, STLOptions, STLModel;

// SVG Loader (Vector Graphics)
export '../src/loaders/svg_loader.dart' 
    show SVGLoader, SVGOptions, SVGData;

// TDS Loader (3D Studio)
export '../src/loaders/tds_loader.dart' 
    show TDSLoader, TDSOptions, StudioMax;

// TTF Loader (TrueType Font)
export '../src/loaders/ttf_loader.dart' 
    show TTFLoader, TTFOptions, TrueTypeFont;

// VRM Loader (Virtual Reality Model)
export '../src/loaders/vrm_loader.dart' 
    show VRMLoader, VRMOptions, VRMAvatar;

// VRML Loader (Virtual Reality Modeling Language)
export '../src/loaders/vrml_loader.dart' 
    show VRMLLoader, VRMLOptions, VRMLScene;

// X Loader (DirectX Model)
export '../src/loaders/x_loader.dart' 
    show XLoader, XOptions, XFileFormat;
