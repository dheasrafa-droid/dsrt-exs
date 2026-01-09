/// Rendering System API for DSRT Engine
/// 
/// Provides rendering pipeline, shader management, post-processing,
/// and graphics backend abstraction.
/// 
/// [includeWebGL]: Whether to include WebGL renderer.
/// Defaults to true for web platforms.
library dsrt_engine.public.renderer;

// Renderer Base Class
export '../src/renderer/renderer.dart' 
    show Renderer, RendererType, RendererState;

// Render Target
export '../src/renderer/render_target.dart' 
    show RenderTarget, TargetType;

// Render List
export '../src/renderer/render_list.dart' 
    show RenderList, RenderItem;

// Render Queue
export '../src/renderer/render_queue.dart' 
    show RenderQueue, QueuePriority;

// Render Pass
export '../src/renderer/render_pass.dart' 
    show RenderPass, PassType;

// Render Context
export '../src/renderer/render_context.dart' 
    show RenderContext, ContextState;

// Render Statistics
export '../src/renderer/render_stats.dart' 
    show RenderStats, FrameStats;

// Render Utilities
export '../src/renderer/render_utils.dart' 
    show RenderUtils, RenderHelpers;

// Render Serialization
export '../src/renderer/render_serializer.dart' 
    show RenderSerializer, RenderData;

// Render Validation
export '../src/renderer/render_validator.dart' 
    show RenderValidator, RenderValidation;

// Render Optimization
export '../src/renderer/render_optimizer.dart' 
    show RenderOptimizer, OptimizationLevel;

// Render Manager
export '../src/renderer/render_manager.dart' 
    show RenderManager, RenderPipeline;

// Render Factory
export '../src/renderer/render_factory.dart' 
    show RenderFactory, FactoryOptions;

// Render Configuration
export '../src/renderer/render_config.dart' 
    show RenderConfig, ConfigPreset;

// Render Capabilities
export '../src/renderer/render_capabilities.dart' 
    show RenderCapabilities, CapabilityTest;

// Render Extensions
export '../src/renderer/render_extensions.dart' 
    show RenderExtensions, ExtensionLoader;

// Render Debugging
export '../src/renderer/render_debug.dart' 
    show RenderDebug, DebugOverlay;

// Render Profiling
export '../src/renderer/render_profiler.dart' 
    show RenderProfiler, ProfilingData;

// Render State Management
export '../src/renderer/state/render_state.dart' 
    show RenderState, StateBlock;

// Depth State
export '../src/renderer/state/depth_state.dart' 
    show DepthState, DepthTest, DepthWrite;

// Blending State
export '../src/renderer/state/blending_state.dart' 
    show BlendingState, BlendFunc, BlendEquation;

// Stencil State
export '../src/renderer/state/stencil_state.dart' 
    show StencilState, StencilOp, StencilTest;

// Cull State
export '../src/renderer/state/cull_state.dart' 
    show CullState, CullFace, FrontFace;

// Scissor State
export '../src/renderer/state/scissor_state.dart' 
    show ScissorState, ScissorRect;

// Viewport State
export '../src/renderer/state/viewport_state.dart' 
    show ViewportState, ViewportRect;

// Color State
export '../src/renderer/state/color_state.dart' 
    show ColorState, ColorMask, ClearColor;

// Polygon State
export '../src/renderer/state/polygon_state.dart' 
    show PolygonState, PolygonMode, PolygonOffset;

// Line State
export '../src/renderer/state/line_state.dart' 
    show LineState, LineWidth, LineStipple;

// Point State
export '../src/renderer/state/point_state.dart' 
    show PointState, PointSize, PointSprite;

// State Manager
export '../src/renderer/state/state_manager.dart' 
    show StateManager, StateCache;

// State Utilities
export '../src/renderer/state/state_utils.dart' 
    show StateUtils, StateHelpers;

// WebGL Renderer
export '../src/renderer/webgl/webgl_renderer.dart' 
    show WebGLRenderer, WebGLVersion;

// WebGL Program
export '../src/renderer/webgl/webgl_program.dart' 
    show WebGLProgram, ProgramInfo;

// WebGL Buffer
export '../src/renderer/webgl/webgl_buffer.dart' 
    show WebGLBuffer, BufferType;

// WebGL Texture
export '../src/renderer/webgl/webgl_texture.dart' 
    show WebGLTexture, TextureUnit;

// WebGL Framebuffer
export '../src/renderer/webgl/webgl_framebuffer.dart' 
    show WebGLFramebuffer, FramebufferAttachment;

// WebGL Renderbuffer
export '../src/renderer/webgl/webgl_renderbuffer.dart' 
    show WebGLRenderbuffer, RenderbufferFormat;

// WebGL Extensions
export '../src/renderer/webgl/webgl_extensions.dart' 
    show WebGLExtensions, ExtensionList;

// WebGL Capabilities
export '../src/renderer/webgl/webgl_capabilities.dart' 
    show WebGLCapabilities, CapabilityInfo;

// WebGL Info
export '../src/renderer/webgl/webgl_info.dart' 
    show WebGLInfo, ContextInfo;

// WebGL Utilities
export '../src/renderer/webgl/webgl_utils.dart' 
    show WebGLUtils, WebGLHelpers;

// WebGL Constants
export '../src/renderer/webgl/webgl_constants.dart' 
    show WebGLConstants, GLenum;

// WebGL Shader
export '../src/renderer/webgl/webgl_shader.dart' 
    show WebGLShader, ShaderType;

// WebGL Uniform
export '../src/renderer/webgl/webgl_uniform.dart' 
    show WebGLUniform, UniformLocation;

// WebGL Attribute
export '../src/renderer/webgl/webgl_attribute.dart' 
    show WebGLAttribute, AttributeLocation;

// WebGL Geometry
export '../src/renderer/webgl/webgl_geometry.dart' 
    show WebGLGeometry, GeometryBinding;

// WebGL Material
export '../src/renderer/webgl/webgl_material.dart' 
    show WebGLMaterial, MaterialProgram;

// WebGL Objects
export '../src/renderer/webgl/webgl_objects.dart' 
    show WebGLObjects, ObjectRegistry;

// WebGL Backend
export '../src/renderer/webgl/webgl_backend.dart' 
    show WebGLBackend, BackendConfig;

// WebGL Context
export '../src/renderer/webgl/webgl_context.dart' 
    show WebGLContext, ContextAttributes;

// WebGL Manager
export '../src/renderer/webgl/webgl_manager.dart' 
    show WebGLManager, ManagerConfig;

// WebGL Debugging
export '../src/renderer/webgl/webgl_debug.dart' 
    show WebGLDebug, DebugTools;

// Shadow Mapping
export '../src/renderer/shadows/shadow_map.dart' 
    show ShadowMap, ShadowType;

// Shadow Pass
export '../src/renderer/shadows/shadow_pass.dart' 
    show ShadowPass, PassConfig;

// Shadow Caster
export '../src/renderer/shadows/shadow_caster.dart' 
    show ShadowCaster, CasterInfo;

// Shadow Receiver
export '../src/renderer/shadows/shadow_receiver.dart' 
    show ShadowReceiver, ReceiverInfo;

// Shadow Utilities
export '../src/renderer/shadows/shadow_utils.dart' 
    show ShadowUtils, ShadowHelpers;

// Shadow Manager
export '../src/renderer/shadows/shadow_manager.dart' 
    show ShadowManager, ShadowSystem;

// Shadow Configuration
export '../src/renderer/shadows/shadow_config.dart' 
    show ShadowConfig, ShadowQuality;

// Shadow Filtering
export '../src/renderer/shadows/shadow_filter.dart' 
    show ShadowFilter, FilterType;

// Shadow Debugging
export '../src/renderer/shadows/shadow_debug.dart' 
    show ShadowDebug, DebugVisualization;

// Shadow Optimization
export '../src/renderer/shadows/shadow_optimizer.dart' 
    show ShadowOptimizer, OptimizationSettings;

// Effect Composer
export '../src/renderer/postprocess/effect_composer.dart' 
    show EffectComposer, ComposerConfig;

// Render Pass (Post-process)
export '../src/renderer/postprocess/render_pass.dart' 
    show PostProcessPass, PassOrder;

// Shader Pass
export '../src/renderer/postprocess/shader_pass.dart' 
    show ShaderPass, ShaderMaterial;

// Clear Pass
export '../src/renderer/postprocess/clear_pass.dart' 
    show ClearPass, ClearOptions;

// Mask Pass
export '../src/renderer/postprocess/mask_pass.dart' 
    show MaskPass, MaskType;

// Copy Pass
export '../src/renderer/postprocess/copy_pass.dart' 
    show CopyPass, CopyOptions;

// Texture Pass
export '../src/renderer/postprocess/texture_pass.dart' 
    show TexturePass, TextureSource;

// Post-process Utilities
export '../src/renderer/postprocess/post_process_utils.dart' 
    show PostProcessUtils, PostProcessHelpers;

// Post-process Manager
export '../src/renderer/postprocess/post_process_manager.dart' 
    show PostProcessManager, ManagerOptions;

// Post-process Configuration
export '../src/renderer/postprocess/post_process_config.dart' 
    show PostProcessConfig, ConfigOptions;

// Bloom Pass
export '../src/renderer/postprocess/passes/bloom_pass.dart' 
    show BloomPass, BloomParams;

// SSAO Pass
export '../src/renderer/postprocess/passes/ssao_pass.dart' 
    show SSAOPass, SSAOParams;

// FXAA Pass
export '../src/renderer/postprocess/passes/fxaa_pass.dart' 
    show FXAAPass, FXAAParams;

// Depth of Field Pass
export '../src/renderer/postprocess/passes/dof_pass.dart' 
    show DOFPass, DOFParams;

// Color Correction Pass
export '../src/renderer/postprocess/passes/color_correction_pass.dart' 
    show ColorCorrectionPass, CorrectionParams;

// Film Pass
export '../src/renderer/postprocess/passes/film_pass.dart' 
    show FilmPass, FilmParams;

// Glitch Pass
export '../src/renderer/postprocess/passes/glitch_pass.dart' 
    show GlitchPass, GlitchParams;

// Halftone Pass
export '../src/renderer/postprocess/passes/halftone_pass.dart' 
    show HalftonePass, HalftoneParams;

// Kaleido Pass
export '../src/renderer/postprocess/passes/kaleido_pass.dart' 
    show KaleidoPass, KaleidoParams;

// LUT Pass
export '../src/renderer/postprocess/passes/lut_pass.dart' 
    show LUTPass, LUTParams;

// Pixelate Pass
export '../src/renderer/postprocess/passes/pixelate_pass.dart' 
    show PixelatePass, PixelateParams;

// SAO Pass
export '../src/renderer/postprocess/passes/sao_pass.dart' 
    show SAOPass, SAOParams;

// SSR Pass
export '../src/renderer/postprocess/passes/ssr_pass.dart' 
    show SSRPass, SSRParams;

// TAA Pass
export '../src/renderer/postprocess/passes/taa_pass.dart' 
    show TAAPass, TAAParams;

// Terrain Pass
export '../src/renderer/postprocess/passes/terrain_pass.dart' 
    show TerrainPass, TerrainParams;

// Unreal Bloom Pass
export '../src/renderer/postprocess/passes/unreal_bloom_pass.dart' 
    show UnrealBloomPass, BloomParams;

// Water Pass
export '../src/renderer/postprocess/passes/water_pass.dart' 
    show WaterPass, WaterParams;

// Motion Blur Pass
export '../src/renderer/postprocess/passes/motion_blur_pass.dart' 
    show MotionBlurPass, MotionBlurParams;

// Vignette Pass
export '../src/renderer/postprocess/passes/vignette_pass.dart' 
    show VignettePass, VignetteParams;

// Grain Pass
export '../src/renderer/postprocess/passes/grain_pass.dart' 
    show GrainPass, GrainParams;

// Chromatic Aberration Pass
export '../src/renderer/postprocess/passes/chromatic_aberration_pass.dart' 
    show ChromaticAberrationPass, AberrationParams;

// Lens Distortion Pass
export '../src/renderer/postprocess/passes/lens_distortion_pass.dart' 
    show LensDistortionPass, DistortionParams;

// Shader Library
export '../src/renderer/shaders/shader_lib.dart' 
    show ShaderLibrary, LibraryEntry;

// Shader Chunks
export '../src/renderer/shaders/shader_chunk.dart' 
    show ShaderChunk, ChunkType;

// Shader Utilities
export '../src/renderer/shaders/shader_utils.dart' 
    show ShaderUtils, ShaderHelpers;

// Shader Compiler
export '../src/renderer/shaders/shader_compiler.dart' 
    show ShaderCompiler, CompileOptions;

// Shader Builder
export '../src/renderer/shaders/shader_builder.dart' 
    show ShaderBuilder, BuilderOptions;

// Shader Cache
export '../src/renderer/shaders/shader_cache.dart' 
    show ShaderCache, CacheSystem;

// Shader Manager
export '../src/renderer/shaders/shader_manager.dart' 
    show ShaderManager, ManagerConfig;

// Shader Parser
export '../src/renderer/shaders/shader_parser.dart' 
    show ShaderParser, ParseResult;

// Shader Validator
export '../src/renderer/shaders/shader_validator.dart' 
    show ShaderValidator, ValidationResult;

// Shader Optimizer
export '../src/renderer/shaders/shader_optimizer.dart' 
    show ShaderOptimizer, OptimizationResult;

// Uniform System
export '../src/renderer/shaders/uniforms/uniform.dart' 
    show Uniform, UniformType;

// Uniform Utilities
export '../src/renderer/shaders/uniforms/uniform_utils.dart' 
    show UniformUtils, UniformHelpers;

// Uniform Library
export '../src/renderer/shaders/uniforms/uniform_lib.dart' 
    show UniformLibrary, LibrarySystem;

// Uniform Manager
export '../src/renderer/shaders/uniforms/uniform_manager.dart' 
    show UniformManager, ManagerSystem;

// Uniform Cache
export '../src/renderer/shaders/uniforms/uniform_cache.dart' 
    show UniformCache, CacheSystem;

// Uniform Serialization
export '../src/renderer/shaders/uniforms/uniform_serializer.dart' 
    show UniformSerializer, Serialization;

// Uniform Validation
export '../src/renderer/shaders/uniforms/uniform_validator.dart' 
    show UniformValidator, Validation;

// Uniform Types
export '../src/renderer/shaders/uniforms/uniform_types.dart' 
    show UniformTypes, TypeSystem;

// Shader Chunk Manager
export '../src/renderer/shaders/chunks/chunk_manager.dart' 
    show ChunkManager, ManagerConfig;

// Shader Program Manager
export '../src/renderer/shaders/programs/program_manager.dart' 
    show ProgramManager, ManagerSystem;

// Basic Program
export '../src/renderer/shaders/programs/basic_program.dart' 
    show BasicProgram, ProgramConfig;

// Standard Program
export '../src/renderer/shaders/programs/standard_program.dart' 
    show StandardProgram, ProgramConfig;

// Physical Program
export '../src/renderer/shaders/programs/physical_program.dart' 
    show PhysicalProgram, ProgramConfig;

// Custom Shader Program
export '../src/renderer/shaders/programs/shader_program.dart' 
    show CustomShaderProgram, ProgramConfig;

// Line Program
export '../src/renderer/shaders/programs/line_program.dart' 
    show LineProgram, ProgramConfig;

// Points Program
export '../src/renderer/shaders/programs/points_program.dart' 
    show PointsProgram, ProgramConfig;

// Sprite Program
export '../src/renderer/shaders/programs/sprite_program.dart' 
    show SpriteProgram, ProgramConfig;

// Depth Program
export '../src/renderer/shaders/programs/depth_program.dart' 
    show DepthProgram, ProgramConfig;

// Distance Program
export '../src/renderer/shaders/programs/distance_program.dart' 
    show DistanceProgram, ProgramConfig;

// Normal Program
export '../src/renderer/shaders/programs/normal_program.dart' 
    show NormalProgram, ProgramConfig;

// MatCap Program
export '../src/renderer/shaders/programs/matcap_program.dart' 
    show MatCapProgram, ProgramConfig;

// Toon Program
export '../src/renderer/shaders/programs/toon_program.dart' 
    show ToonProgram, ProgramConfig;

// Program Cache
export '../src/renderer/shaders/programs/program_cache.dart' 
    show ProgramCache, CacheSystem;

// Program Compiler
export '../src/renderer/shaders/programs/program_compiler.dart' 
    show ProgramCompiler, CompileSystem;

// Program Validator
export '../src/renderer/shaders/programs/program_validator.dart' 
    show ProgramValidator, ValidationSystem;

// Forward Rendering Pipeline
export '../src/renderer/pipelines/forward_pipeline.dart' 
    show ForwardPipeline, PipelineConfig;

// Deferred Rendering Pipeline
export '../src/renderer/pipelines/deferred_pipeline.dart' 
    show DeferredPipeline, PipelineConfig;

// Pipeline Utilities
export '../src/renderer/pipelines/pipeline_utils.dart' 
    show PipelineUtils, PipelineHelpers;

// Pipeline Manager
export '../src/renderer/pipelines/pipeline_manager.dart' 
    show PipelineManager, ManagerConfig;

// Pipeline Configuration
export '../src/renderer/pipelines/pipeline_config.dart' 
    show PipelineConfig, ConfigOptions;

// Pipeline Optimization
export '../src/renderer/pipelines/pipeline_optimizer.dart' 
    show PipelineOptimizer, OptimizationSystem;

// Compute Renderer
export '../src/renderer/compute/compute_renderer.dart' 
    show ComputeRenderer, ComputeBackend;

// Compute Pass
export '../src/renderer/compute/compute_pass.dart' 
    show ComputePass, PassConfig;

// Compute Kernel
export '../src/renderer/compute/compute_kernel.dart' 
    show ComputeKernel, KernelSource;

// Compute Buffer
export '../src/renderer/compute/compute_buffer.dart' 
    show ComputeBuffer, BufferConfig;

// Compute Texture
export '../src/renderer/compute/compute_texture.dart' 
    show ComputeTexture, TextureConfig;

// Compute Utilities
export '../src/renderer/compute/compute_utils.dart' 
    show ComputeUtils, ComputeHelpers;

// Compute Manager
export '../src/renderer/compute/compute_manager.dart' 
    show ComputeManager, ManagerConfig;

// WebGPU Renderer
export '../src/renderer/webgpu/webgpu_renderer.dart' 
    show WebGPURenderer, GPUDevice;

// WebGPU Utilities
export '../src/renderer/webgpu/webgpu_utils.dart' 
    show WebGPUUtils, GPUHelpers;

// WebGPU Context
export '../src/renderer/webgpu/webgpu_context.dart' 
    show WebGPUContext, ContextConfig;

// WebGPU Buffer
export '../src/renderer/webgpu/webgpu_buffer.dart' 
    show WebGPUBuffer, BufferUsage;

// WebGPU Texture
export '../src/renderer/webgpu/webgpu_texture.dart' 
    show WebGPUTexture, TextureUsage;

// WebGPU Shader
export '../src/renderer/webgpu/webgpu_shader.dart' 
    show WebGPUShader, ShaderModule;

// WebGPU Manager
export '../src/renderer/webgpu/webgpu_manager.dart' 
    show WebGPUManager, ManagerConfig;

// SVG Renderer (Fallback)
export '../src/renderer/fallback/svg_renderer.dart' 
    show SVGRenderer, SVGConfig;

// CSS3D Renderer (Fallback)
export '../src/renderer/fallback/css3d_renderer.dart' 
    show CSS3DRenderer, CSS3DConfig;

// Software Renderer (Fallback)
export '../src/renderer/fallback/software_renderer.dart' 
    show SoftwareRenderer, SoftwareConfig;

// Fallback Manager
export '../src/renderer/fallback/fallback_manager.dart' 
    show FallbackManager, ManagerConfig;
