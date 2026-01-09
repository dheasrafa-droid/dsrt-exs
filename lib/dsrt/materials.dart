/// Material System API for DSRT Engine
/// 
/// Provides material creation, management, and shading for 3D objects.
/// 
/// [includeShaders]: Whether to include shader material features.
/// Defaults to true.
library dsrt_engine.public.materials;

// Material Base Class
export '../src/materials/material.dart' 
    show Material, MaterialType, MaterialState;

// Material Properties
export '../src/materials/material_properties.dart' 
    show MaterialProperties, PropertyMap;

// Material Utilities
export '../src/materials/material_utils.dart' 
    show MaterialUtils, MaterialOperations;

// Material Serialization
export '../src/materials/material_serializer.dart' 
    show MaterialSerializer, MaterialData;

// Material Validation
export '../src/materials/material_validator.dart' 
    show MaterialValidator, MaterialValidation;

// Material Manager
export '../src/materials/material_manager.dart' 
    show MaterialManager, MaterialCache;

// Material Factory
export '../src/materials/material_factory.dart' 
    show MaterialFactory, MaterialPreset;

// Material Cache
export '../src/materials/material_cache.dart' 
    show MaterialCache, CacheEntry;

// Material Compiler
export '../src/materials/material_compiler.dart' 
    show MaterialCompiler, CompilationResult;

// Material Builder
export '../src/materials/material_builder.dart' 
    show MaterialBuilder, BuilderOptions;

// Material Shader
export '../src/materials/material_shader.dart' 
    show MaterialShader, ShaderSource;

// Material Uniforms
export '../src/materials/material_uniforms.dart' 
    show MaterialUniforms, UniformValue;

// Material Defines
export '../src/materials/material_defines.dart' 
    show MaterialDefines, DefineMap;

// Basic Material
export '../src/materials/basic.dart' 
    show BasicMaterial, BasicMaterialParams;

// Standard Material
export '../src/materials/standard.dart' 
    show StandardMaterial, StandardMaterialParams;

// Physical Material (PBR)
export '../src/materials/physical.dart' 
    show PhysicalMaterial, PBRParams;

// Shader Material
export '../src/materials/shader.dart' 
    show ShaderMaterial, CustomShader;

// Line Basic Material
export '../src/materials/line_basic.dart' 
    show LineBasicMaterial, LineMaterialParams;

// Line Dashed Material
export '../src/materials/line_dashed.dart' 
    show LineDashedMaterial, DashPattern;

// Points Material
export '../src/materials/points_material.dart' 
    show PointsMaterial, PointsParams;

// Sprite Material
export '../src/materials/sprite_material.dart' 
    show SpriteMaterial, SpriteParams;

// Shadow Material
export '../src/materials/shadow_material.dart' 
    show ShadowMaterial, ShadowParams;

// Depth Material
export '../src/materials/depth_material.dart' 
    show DepthMaterial, DepthParams;

// Distance Material
export '../src/materials/distance_material.dart' 
    show DistanceMaterial, DistanceParams;

// Mesh Distance Material
export '../src/materials/mesh_distance_material.dart' 
    show MeshDistanceMaterial, MeshDistanceParams;

// Mesh MatCap Material
export '../src/materials/mesh_matcap_material.dart' 
    show MeshMatcapMaterial, MatCapParams;

// Mesh Toon Material
export '../src/materials/mesh_toon_material.dart' 
    show MeshToonMaterial, ToonParams;

// Mesh Normal Material
export '../src/materials/mesh_normal_material.dart' 
    show MeshNormalMaterial, NormalParams;

// Mesh Phong Material
export '../src/materials/mesh_phong_material.dart' 
    show MeshPhongMaterial, PhongParams;

// Mesh Lambert Material
export '../src/materials/mesh_lambert_material.dart' 
    show MeshLambertMaterial, LambertParams;

// Mesh Basic Material
export '../src/materials/mesh_basic_material.dart' 
    show MeshBasicMaterial, MeshBasicParams;

// Mesh Standard Material
export '../src/materials/mesh_standard_material.dart' 
    show MeshStandardMaterial, MeshStandardParams;

// Mesh Physical Material
export '../src/materials/mesh_physical_material.dart' 
    show MeshPhysicalMaterial, MeshPhysicalParams;

// Mesh Shader Material
export '../src/materials/mesh_shader_material.dart' 
    show MeshShaderMaterial, MeshShaderParams;

// Canvas Material
export '../src/materials/canvas_material.dart' 
    show CanvasMaterial, CanvasParams;

// Video Material
export '../src/materials/video_material.dart' 
    show VideoMaterial, VideoParams;

// Cube Material
export '../src/materials/cube_material.dart' 
    show CubeMaterial, CubeParams;

// Environment Material
export '../src/materials/environment_material.dart' 
    show EnvironmentMaterial, EnvironmentParams;

// Skybox Material
export '../src/materials/skybox_material.dart' 
    show SkyboxMaterial, SkyboxParams;

// Post Process Material
export '../src/materials/post_process_material.dart' 
    show PostProcessMaterial, PostProcessParams;
