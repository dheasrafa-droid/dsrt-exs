/// Development Tools API for DSRT Engine
/// 
/// Provides editor tools, inspectors, exporters, optimizers,
/// and validators for development and content creation.
/// 
/// [includeEditors]: Whether to include editor interfaces.
/// Defaults to false in production.
library dsrt_engine.public.tools;

// Scene Editor
export '../src/tools/editor/scene_editor.dart' 
    show SceneEditor, EditorState, Toolset;

// Object Editor
export '../src/tools/editor/object_editor.dart' 
    show ObjectEditor, TransformGizmo, Manipulator;

// Material Editor
export '../src/tools/editor/material_editor.dart' 
    show MaterialEditor, ShaderGraph, NodeEditor;

// Animation Editor
export '../src/tools/editor/animation_editor.dart' 
    show AnimationEditor, Timeline, KeyframeEditor;

// Physics Editor
export '../src/tools/editor/physics_editor.dart' 
    show PhysicsEditor, CollisionVisualizer, ConstraintEditor;

// UI Editor
export '../src/tools/editor/ui_editor.dart' 
    show UIEditor, LayoutEditor, ComponentPalette;

// Editor Manager
export '../src/tools/editor/editor_manager.dart' 
    show EditorManager, Workspace, Project;

// Editor Utilities
export '../src/tools/editor/editor_utils.dart' 
    show EditorUtils, Clipboard, UndoRedo;

// Editor Configuration
export '../src/tools/editor/editor_config.dart' 
    show EditorConfig, Preferences, Shortcuts;

// Editor Serialization
export '../src/tools/editor/editor_serializer.dart' 
    show EditorSerializer, ProjectFile;

// Scene Inspector
export '../src/tools/inspectors/scene_inspector.dart' 
    show SceneInspector, HierarchyView, ComponentList;

// Object Inspector
export '../src/tools/inspectors/object_inspector.dart' 
    show ObjectInspector, PropertyEditor, TransformEditor;

// Material Inspector
export '../src/tools/inspectors/material_inspector.dart' 
    show MaterialInspector, ShaderProperties, TextureSlots;

// Animation Inspector
export '../src/tools/inspectors/animation_inspector.dart' 
    show AnimationInspector, ClipPreview, CurveEditor;

// Physics Inspector
export '../src/tools/inspectors/physics_inspector.dart' 
    show PhysicsInspector, CollisionDebugger, ForceVisualizer;

// Performance Inspector
export '../src/tools/inspectors/performance_inspector.dart' 
    show PerformanceInspector, MetricsDashboard, FrameAnalyzer;

// Memory Inspector
export '../src/tools/inspectors/memory_inspector.dart' 
    show MemoryInspector, AllocationTracker, LeakDetector;

// Inspector Manager
export '../src/tools/inspectors/inspector_manager.dart' 
    show InspectorManager, PanelSystem;

// Inspector Utilities
export '../src/tools/inspectors/inspector_utils.dart' 
    show InspectorUtils, DataBinding;

// GLTF Exporter
export '../src/tools/exporters/gltf_exporter.dart' 
    show GLTFExporter, ExportOptions, BinaryGLB;

// OBJ Exporter
export '../src/tools/exporters/obj_exporter.dart' 
    show OBJExporter, MaterialLibrary, Grouping;

// STL Exporter
export '../src/tools/exporters/stl_exporter.dart' 
    show STLExporter, BinaryExport, ASCIIExport;

// PLY Exporter
export '../src/tools/exporters/ply_exporter.dart' 
    show PLYExporter, VertexColors, Normals;

// Draco Exporter (Compression)
export '../src/tools/exporters/draco_exporter.dart' 
    show DracoExporter, CompressionSettings, Quantization;

// Collada Exporter
export '../src/tools/exporters/collada_exporter.dart' 
    show ColladaExporter, DAEFormat, AnimationClips;

// Exporter Manager
export '../src/tools/exporters/exporter_manager.dart' 
    show ExporterManager, FormatRegistry;

// Exporter Utilities
export '../src/tools/exporters/exporter_utils.dart' 
    show ExporterUtils, BatchExport;

// Mesh Optimizer
export '../src/tools/optimizers/mesh_optimizer.dart' 
    show MeshOptimizer, VertexCache, Overdraw;

// Texture Optimizer
export '../src/tools/optimizers/texture_optimizer.dart' 
    show TextureOptimizer, Compression, MipmapGeneration;

// Scene Optimizer
export '../src/tools/optimizers/scene_optimizer.dart' 
    show SceneOptimizer, Batching, Instancing;

// LOD Generator
export '../src/tools/optimizers/lod_generator.dart' 
    show LODGenerator, ReductionAlgorithm, QualityLevels;

// Occlusion Culler
export '../src/tools/optimizers/occlusion_culler.dart' 
    show OcclusionCuller, PVS, OcclusionQuery;

// Optimizer Manager
export '../src/tools/optimizers/optimizer_manager.dart' 
    show OptimizerManager, OptimizationPipeline;

// Optimizer Utilities
export '../src/tools/optimizers/optimizer_utils.dart' 
    show OptimizerUtils, AnalysisTools;

// Scene Validator
export '../src/tools/validators/scene_validator.dart' 
    show SceneValidator, IntegrityCheck, DependencyGraph;

// Material Validator
export '../src/tools/validators/material_validator.dart' 
    show MaterialValidator, ShaderCompilation, TextureValidation;

// Animation Validator
export '../src/tools/validators/animation_validator.dart' 
    show AnimationValidator, KeyframeConsistency, CurveSmoothness;

// Physics Validator
export '../src/tools/validators/physics_validator.dart' 
    show PhysicsValidator, CollisionMesh, ConstraintStability;

// Validator Manager
export '../src/tools/validators/validator_manager.dart' 
    show ValidatorManager, ValidationPipeline;

// Validator Utilities
export '../src/tools/validators/validator_utils.dart' 
    show ValidatorUtils, ReportGenerator;
