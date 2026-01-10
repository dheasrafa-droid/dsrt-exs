/// Core constants and configuration values for DSRT Engine.
/// 
/// These values define engine behavior, limits, and default configurations.
/// Not intended for public modification.
/// 
/// [DSRT]: Dart Spatial Rendering Technology
/// 
/// @internal - Core engine internals
library dsrt.core.constants;

/// Engine precision constant for floating-point comparisons
const double dsrtEpsilon = 1e-6;

/// Maximum number of directional lights supported per scene
const int dsrtMaxDirectionalLights = 4;

/// Maximum number of point lights supported per scene
const int dsrtMaxPointLights = 8;

/// Maximum number of spot lights supported per scene
const int dsrtMaxSpotLights = 4;

/// Maximum number of bones per skeleton for skinning
const int dsrtMaxBonesPerSkeleton = 128;

/// Default animation frame rate in frames per second
const double dsrtDefaultFrameRate = 60.0;

/// Maximum supported texture size in pixels
const int dsrtMaxTextureSize = 8192;

/// Maximum number of vertices per geometry buffer
const int dsrtMaxVerticesPerBuffer = 65536;

/// Maximum number of indices per geometry buffer
const int dsrtMaxIndicesPerBuffer = 131072;

/// Default near clipping plane distance for cameras
const double dsrtDefaultCameraNear = 0.1;

/// Default far clipping plane distance for cameras
const double dsrtDefaultCameraFar = 2000.0;

/// Default field of view for perspective cameras in degrees
const double dsrtDefaultPerspectiveFOV = 60.0;

/// Default orthographic camera size
const double dsrtDefaultOrthographicSize = 5.0;

/// Default render target width in pixels
const int dsrtDefaultRenderWidth = 1024;

/// Default render target height in pixels
const int dsrtDefaultRenderHeight = 768;

/// Maximum number of render targets in a framebuffer
const int dsrtMaxRenderTargets = 8;

/// Maximum number of texture units available
const int dsrtMaxTextureUnits = 16;

/// Maximum number of uniform buffer binding points
const int dsrtMaxUniformBufferBindings = 12;

/// Maximum number of vertex attributes per shader
const int dsrtMaxVertexAttributes = 16;

/// Default clear color (RGBA)
const List<double> dsrtDefaultClearColor = [0.0, 0.0, 0.0, 1.0];

/// Default clear depth value
const double dsrtDefaultClearDepth = 1.0;

/// Default clear stencil value
const int dsrtDefaultClearStencil = 0;

/// Size of a single matrix in bytes (4x4 float matrix)
const int dsrtMatrixByteSize = 64;

/// Size of a single vector4 in bytes
const int dsrtVector4ByteSize = 16;

/// Size of a single vector3 in bytes
const int dsrtVector3ByteSize = 12;

/// Size of a single vector2 in bytes
const int dsrtVector2ByteSize = 8;

/// Maximum mipmap levels for textures
const int dsrtMaxMipmapLevels = 12;

/// Default anisotropy level for texture filtering
const double dsrtDefaultAnisotropy = 4.0;

/// Default gamma correction value
const double dsrtDefaultGamma = 2.2;

/// Default exposure value for tone mapping
const double dsrtDefaultExposure = 1.0;

/// Default white point for tone mapping
const double dsrtDefaultWhitePoint = 1.0;

/// Default ambient light intensity
const double dsrtDefaultAmbientIntensity = 0.1;

/// Default directional light intensity
const double dsrtDefaultDirectionalIntensity = 1.0;

/// Default point light intensity
const double dsrtDefaultPointIntensity = 1.0;

/// Default spot light intensity
const double dsrtDefaultSpotIntensity = 1.0;

/// Default shadow bias value
const double dsrtDefaultShadowBias = 0.001;

/// Default shadow normal bias value
const double dsrtDefaultShadowNormalBias = 0.001;

/// Default shadow map size
const int dsrtDefaultShadowMapSize = 1024;

/// Default bloom threshold
const double dsrtDefaultBloomThreshold = 0.8;

/// Default bloom intensity
const double dsrtDefaultBloomIntensity = 0.5;

/// Default bloom radius
const double dsrtDefaultBloomRadius = 0.5;

/// Default SSAO radius
const double dsrtDefaultSSAORadius = 0.5;

/// Default SSAO intensity
const double dsrtDefaultSSAOIntensity = 1.0;

/// Default SSAO bias
const double dsrtDefaultSSAOBias = 0.025;

/// Default FXAA quality
const double dsrtDefaultFXAAQuality = 0.25;

/// Default motion blur samples
const int dsrtDefaultMotionBlurSamples = 16;

/// Default motion blur intensity
const double dsrtDefaultMotionBlurIntensity = 0.5;

/// Default depth of field focus distance
const double dsrtDefaultDOFFocusDistance = 10.0;

/// Default depth of field aperture
const double dsrtDefaultDOFAperture = 0.1;

/// Default depth of field max blur
const double dsrtDefaultDOFMaxBlur = 0.02;

/// Shader precision qualifier for high precision
const String dsrtShaderPrecisionHighp = 'highp';

/// Shader precision qualifier for medium precision
const String dsrtShaderPrecisionMediump = 'mediump';

/// Shader precision qualifier for low precision
const String dsrtShaderPrecisionLowp = 'lowp';

/// Shader attribute location for position
const int dsrtShaderAttributePosition = 0;

/// Shader attribute location for normal
const int dsrtShaderAttributeNormal = 1;

/// Shader attribute location for uv
const int dsrtShaderAttributeUV = 2;

/// Shader attribute location for color
const int dsrtShaderAttributeColor = 3;

/// Shader attribute location for tangent
const int dsrtShaderAttributeTangent = 4;

/// Shader attribute location for bitangent
const int dsrtShaderAttributeBitangent = 5;

/// Shader attribute location for bone indices
const int dsrtShaderAttributeBoneIndices = 6;

/// Shader attribute location for bone weights
const int dsrtShaderAttributeBoneWeights = 7;

/// Shader attribute location for instance matrix
const int dsrtShaderAttributeInstanceMatrix = 8;

/// Shader attribute location for instance color
const int dsrtShaderAttributeInstanceColor = 12;

/// Shader uniform location for model matrix
const String dsrtShaderUniformModelMatrix = 'uModelMatrix';

/// Shader uniform location for view matrix
const String dsrtShaderUniformViewMatrix = 'uViewMatrix';

/// Shader uniform location for projection matrix
const String dsrtShaderUniformProjectionMatrix = 'uProjectionMatrix';

/// Shader uniform location for normal matrix
const String dsrtShaderUniformNormalMatrix = 'uNormalMatrix';

/// Shader uniform location for camera position
const String dsrtShaderUniformCameraPosition = 'uCameraPosition';

/// Shader uniform location for ambient light color
const String dsrtShaderUniformAmbientLightColor = 'uAmbientLightColor';

/// Shader uniform location for directional lights
const String dsrtShaderUniformDirectionalLights = 'uDirectionalLights';

/// Shader uniform location for point lights
const String dsrtShaderUniformPointLights = 'uPointLights';

/// Shader uniform location for spot lights
const String dsrtShaderUniformSpotLights = 'uSpotLights';

/// Shader uniform location for shadow maps
const String dsrtShaderUniformShadowMaps = 'uShadowMaps';

/// Shader uniform location for shadow matrices
const String dsrtShaderUniformShadowMatrices = 'uShadowMatrices';

/// Shader uniform location for time
const String dsrtShaderUniformTime = 'uTime';

/// Shader uniform location for delta time
const String dsrtShaderUniformDeltaTime = 'uDeltaTime';

/// Shader uniform location for resolution
const String dsrtShaderUniformResolution = 'uResolution';

/// Shader uniform location for mouse position
const String dsrtShaderUniformMousePosition = 'uMousePosition';

/// Engine identifier string
const String dsrtEngineIdentifier = 'DSRT Engine';

/// Engine version string
const String dsrtEngineVersion = '0.1.0';

/// Engine build timestamp
const String dsrtEngineBuildTimestamp = '2024-01-15T12:00:00Z';

/// Engine copyright notice
const String dsrtEngineCopyright = '© 2024 DSRT Engine. All rights reserved.';

/// Engine license information
const String dsrtEngineLicense = 'MIT License';

/// Engine repository URL
const String dsrtEngineRepository = 'https://github.com/dheasrafa-droid/dsrt-exs';

/// Engine documentation URL
const String dsrtEngineDocumentation = 'https://dsrt-exs.vercel.app/docs';

/// Engine support email
const String dsrtEngineSupportEmail = 'support@dsrt-engine.com';

/// Default scene name
const String dsrtDefaultSceneName = 'DefaultScene';

/// Default camera name
const String dsrtDefaultCameraName = 'MainCamera';

/// Default light name
const String dsrtDefaultLightName = 'MainLight';

/// Default material name
const String dsrtDefaultMaterialName = 'DefaultMaterial';

/// Default geometry name
const String dsrtDefaultGeometryName = 'DefaultGeometry';

/// Default texture name
const String dsrtDefaultTextureName = 'DefaultTexture';

/// Default shader name
const String dsrtDefaultShaderName = 'DefaultShader';

/// Default animation clip name
const String dsrtDefaultAnimationClipName = 'DefaultAnimation';

/// Default physics world name
const String dsrtDefaultPhysicsWorldName = 'DefaultPhysicsWorld';

/// Default audio context name
const String dsrtDefaultAudioContextName = 'DefaultAudioContext';

/// Default UI manager name
const String dsrtDefaultUIManagerName = 'DefaultUIManager';

/// Maximum name length for engine objects
const int dsrtMaxNameLength = 256;

/// Default cache size for textures in megabytes
const int dsrtDefaultTextureCacheSizeMB = 256;

/// Default cache size for geometries in megabytes
const int dsrtDefaultGeometryCacheSizeMB = 128;

/// Default cache size for materials in megabytes
const int dsrtDefaultMaterialCacheSizeMB = 64;

/// Default cache size for shaders in megabytes
const int dsrtDefaultShaderCacheSizeMB = 32;

/// Default cache size for audio in megabytes
const int dsrtDefaultAudioCacheSizeMB = 64;

/// Maximum number of concurrent downloads
const int dsrtMaxConcurrentDownloads = 4;

/// Default download timeout in seconds
const int dsrtDefaultDownloadTimeoutSeconds = 30;

/// Maximum number of retries for failed downloads
const int dsrtMaxDownloadRetries = 3;

/// Default compression level for assets
const int dsrtDefaultCompressionLevel = 6;

/// Default mipmap generation quality
const int dsrtDefaultMipmapQuality = 1;

/// Default texture filtering mode
const int dsrtDefaultTextureFilter = 0x2601; // GL_LINEAR

/// Default texture wrapping mode
const int dsrtDefaultTextureWrap = 0x2901; // GL_REPEAT

/// Default depth function
const int dsrtDefaultDepthFunc = 0x0203; // GL_LEQUAL

/// Default blend source factor
const int dsrtDefaultBlendSrcFactor = 0x0302; // GL_SRC_ALPHA

/// Default blend destination factor
const int dsrtDefaultBlendDstFactor = 0x0303; // GL_ONE_MINUS_SRC_ALPHA

/// Default blend equation
const int dsrtDefaultBlendEquation = 0x8006; // GL_FUNC_ADD

/// Default cull face mode
const int dsrtDefaultCullFace = 0x0405; // GL_BACK

/// Default front face winding
const int dsrtDefaultFrontFace = 0x0901; // GL_CCW

/// Default polygon mode
const int dsrtDefaultPolygonMode = 0x1B02; // GL_FILL

/// Default stencil function
const int dsrtDefaultStencilFunc = 0x0202; // GL_ALWAYS

/// Default stencil reference value
const int dsrtDefaultStencilRef = 0;

/// Default stencil mask
const int dsrtDefaultStencilMask = 0xFF;

/// Default stencil fail operation
const int dsrtDefaultStencilFailOp = 0x1E00; // GL_KEEP

/// Default stencil zfail operation
const int dsrtDefaultStencilZFailOp = 0x1E00; // GL_KEEP

/// Default stencil zpass operation
const int dsrtDefaultStencilZPassOp = 0x1E00; // GL_KEEP

/// Default scissor test enabled state
const bool dsrtDefaultScissorTestEnabled = false;

/// Default depth test enabled state
const bool dsrtDefaultDepthTestEnabled = true;

/// Default stencil test enabled state
const bool dsrtDefaultStencilTestEnabled = false;

/// Default blend enabled state
const bool dsrtDefaultBlendEnabled = true;

/// Default cull face enabled state
const bool dsrtDefaultCullFaceEnabled = true;

/// Default polygon offset enabled state
const bool dsrtDefaultPolygonOffsetEnabled = false;

/// Default polygon offset factor
const double dsrtDefaultPolygonOffsetFactor = 0.0;

/// Default polygon offset units
const double dsrtDefaultPolygonOffsetUnits = 0.0;

/// Default line width
const double dsrtDefaultLineWidth = 1.0;

/// Default point size
const double dsrtDefaultPointSize = 1.0;

/// Default point sprite enabled state
const bool dsrtDefaultPointSpriteEnabled = false;

/// Default program point size enabled state
const bool dsrtDefaultProgramPointSizeEnabled = false;

/// Default dithering enabled state
const bool dsrtDefaultDitheringEnabled = true;

/// Default color mask red enabled state
const bool dsrtDefaultColorMaskRed = true;

/// Default color mask green enabled state
const bool dsrtDefaultColorMaskGreen = true;

/// Default color mask blue enabled state
const bool dsrtDefaultColorMaskBlue = true;

/// Default color mask alpha enabled state
const bool dsrtDefaultColorMaskAlpha = true;

/// Default depth mask enabled state
const bool dsrtDefaultDepthMask = true;

/// Default stencil mask enabled state
const bool dsrtDefaultStencilMaskEnabled = true;

/// Default sample coverage enabled state
const bool dsrtDefaultSampleCoverageEnabled = false;

/// Default sample coverage value
const double dsrtDefaultSampleCoverageValue = 1.0;

/// Default sample coverage invert state
const bool dsrtDefaultSampleCoverageInvert = false;

/// Default multisample enabled state
const bool dsrtDefaultMultisampleEnabled = true;

/// Default framebuffer sRGB enabled state
const bool dsrtDefaultFramebufferSRGBEnabled = false;

/// Default primitive restart enabled state
const bool dsrtDefaultPrimitiveRestartEnabled = false;

/// Default primitive restart index
const int dsrtDefaultPrimitiveRestartIndex = 0xFFFFFFFF;

/// Maximum uniform block size in bytes
const int dsrtMaxUniformBlockSize = 65536;

/// Maximum uniform buffer size in bytes
const int dsrtMaxUniformBufferSize = 16777216;

/// Maximum shader storage block size in bytes
const int dsrtMaxShaderStorageBlockSize = 134217728;

/// Maximum shader storage buffer size in bytes
const int dsrtMaxShaderStorageBufferSize = 1073741824;

/// Maximum atomic counter buffer size in bytes
const int dsrtMaxAtomicCounterBufferSize = 32768;

/// Maximum transform feedback buffer size in bytes
const int dsrtMaxTransformFeedbackBufferSize = 67108864;

/// Maximum transform feedback separate attribs
const int dsrtMaxTransformFeedbackSeparateAttribs = 4;

/// Maximum transform feedback interleaved attribs
const int dsrtMaxTransformFeedbackInterleavedAttribs = 64;

/// Maximum transform feedback buffers
const int dsrtMaxTransformFeedbackBuffers = 4;

/// Maximum clip distances
const int dsrtMaxClipDistances = 8;

/// Maximum cull distances
const int dsrtMaxCullDistances = 8;

/// Maximum combined clip and cull distances
const int dsrtMaxCombinedClipCullDistances = 8;

/// Maximum viewports
const int dsrtMaxViewports = 16;

/// Maximum viewport dimensions
const int dsrtMaxViewportWidth = 16384;
const int dsrtMaxViewportHeight = 16384;

/// Maximum scissor box dimensions
const int dsrtMaxScissorBoxWidth = 16384;
const int dsrtMaxScissorBoxHeight = 16384;

/// Maximum texture buffer size in texels
const int dsrtMaxTextureBufferSize = 65536;

/// Maximum rectangle texture size
const int dsrtMaxRectangleTextureSize = 16384;

/// Maximum 3D texture size
const int dsrtMax3DTextureSize = 2048;

/// Maximum array texture layers
const int dsrtMaxArrayTextureLayers = 256;

/// Maximum cubemap texture size
const int dsrtMaxCubeMapTextureSize = 16384;

/// Maximum renderbuffer size
const int dsrtMaxRenderbufferSize = 16384;

/// Maximum samples for multisampling
const int dsrtMaxSamples = 32;

/// Maximum color attachments
const int dsrtMaxColorAttachments = 8;

/// Maximum draw buffers
const int dsrtMaxDrawBuffers = 8;

/// Maximum dual source draw buffers
const int dsrtMaxDualSourceDrawBuffers = 1;

/// Maximum elements indices
const int dsrtMaxElementsIndices = 150000;

/// Maximum elements vertices
const int dsrtMaxElementsVertices = 100000;

/// Maximum fragment uniform components
const int dsrtMaxFragmentUniformComponents = 1024;

/// Maximum geometry uniform components
const int dsrtMaxGeometryUniformComponents = 1024;

/// Maximum vertex uniform components
const int dsrtMaxVertexUniformComponents = 1024;

/// Maximum fragment uniform vectors
const int dsrtMaxFragmentUniformVectors = 256;

/// Maximum geometry uniform vectors
const int dsrtMaxGeometryUniformVectors = 256;

/// Maximum vertex uniform vectors
const int dsrtMaxVertexUniformVectors = 256;

/// Maximum varying vectors
const int dsrtMaxVaryingVectors = 15;

/// Maximum fragment atomic counters
const int dsrtMaxFragmentAtomicCounters = 8;

/// Maximum geometry atomic counters
const int dsrtMaxGeometryAtomicCounters = 8;

/// Maximum vertex atomic counters
const int dsrtMaxVertexAtomicCounters = 8;

/// Maximum atomic counter buffer bindings
const int dsrtMaxAtomicCounterBufferBindings = 8;

/// Maximum image uniforms
const int dsrtMaxImageUniforms = 8;

/// Maximum combined image uniforms and fragment outputs
const int dsrtMaxCombinedImageUniformsFragmentOutputs = 8;

/// Maximum image samples
const int dsrtMaxImageSamples = 0;

/// Maximum vertex image uniforms
const int dsrtMaxVertexImageUniforms = 0;

/// Maximum tess control image uniforms
const int dsrtMaxTessControlImageUniforms = 0;

/// Maximum tess evaluation image uniforms
const int dsrtMaxTessEvaluationImageUniforms = 0;

/// Maximum geometry image uniforms
const int dsrtMaxGeometryImageUniforms = 0;

/// Maximum fragment image uniforms
const int dsrtMaxFragmentImageUniforms = 8;

/// Maximum combined image uniforms
const int dsrtMaxCombinedImageUniforms = 48;

/// Maximum combined shader output resources
const int dsrtMaxCombinedShaderOutputResources = 8;

/// Maximum shader storage buffer bindings
const int dsrtMaxShaderStorageBufferBindings = 8;

/// Maximum transform feedback buffers
const int dsrtMaxTransformFeedbackBuffers = 4;

/// Maximum uniform buffer bindings
const int dsrtMaxUniformBufferBindings = 72;

/// Maximum combined uniform blocks
const int dsrtMaxCombinedUniformBlocks = 70;

/// Maximum combined texture image units
const int dsrtMaxCombinedTextureImageUnits = 96;

/// Maximum combined shader storage blocks
const int dsrtMaxCombinedShaderStorageBlocks = 96;

/// Maximum vertex shader storage blocks
const int dsrtMaxVertexShaderStorageBlocks = 16;

/// Maximum geometry shader storage blocks
const int dsrtMaxGeometryShaderStorageBlocks = 16;

/// Maximum tess control shader storage blocks
const int dsrtMaxTessControlShaderStorageBlocks = 16;

/// Maximum tess evaluation shader storage blocks
const int dsrtMaxTessEvaluationShaderStorageBlocks = 16;

/// Maximum fragment shader storage blocks
const int dsrtMaxFragmentShaderStorageBlocks = 16;

/// Maximum compute shader storage blocks
const int dsrtMaxComputeShaderStorageBlocks = 16;

/// Maximum combined image uniforms and shader storage blocks
const int dsrtMaxCombinedImageUniformsShaderStorageBlocks = 8;

/// Maximum debug message length
const int dsrtMaxDebugMessageLength = 1024;

/// Maximum debug stacked messages
const int dsrtMaxDebugStackedMessages = 16;

/// Maximum debug group stack depth
const int dsrtMaxDebugGroupStackDepth = 64;

/// Maximum label length
const int dsrtMaxLabelLength = 256;

/// Default debug output enabled state
const bool dsrtDefaultDebugOutputEnabled = false;

/// Default debug output synchronous state
const bool dsrtDefaultDebugOutputSynchronous = false;

/// Default debug output severity filter
const int dsrtDefaultDebugOutputSeverity = 0x9146; // GL_DEBUG_SEVERITY_NOTIFICATION

/// Default debug output source filter
const int dsrtDefaultDebugOutputSource = 0x824A; // GL_DONT_CARE

/// Default debug output type filter
const int dsrtDefaultDebugOutputType = 0x824B; // GL_DONT_CARE

/// Default debug output IDs to include
const List<int> dsrtDefaultDebugOutputIDs = [];

/// Default debug output IDs to exclude
const List<int> dsrtDefaultDebugOutputExcludeIDs = [];

/// Engine performance profiling sample count
const int dsrtPerformanceProfilingSampleCount = 60;

/// Engine memory monitoring update interval in milliseconds
const int dsrtMemoryMonitoringUpdateInterval = 1000;

/// Engine frame time warning threshold in milliseconds
const double dsrtFrameTimeWarningThreshold = 16.67;

/// Engine frame time critical threshold in milliseconds
const double dsrtFrameTimeCriticalThreshold = 33.33;

/// Engine memory warning threshold in megabytes
const double dsrtMemoryWarningThreshold = 512.0;

/// Engine memory critical threshold in megabytes
const double dsrtMemoryCriticalThreshold = 768.0;

/// Engine GPU memory warning threshold in megabytes
const double dsrtGPUMemoryWarningThreshold = 256.0;

/// Engine GPU memory critical threshold in megabytes
const double dsrtGPUMemoryCriticalThreshold = 384.0;

/// Default frame rate limit
const double dsrtDefaultFrameRateLimit = 0.0; // Unlimited

/// Default vsync enabled state
const bool dsrtDefaultVSyncEnabled = true;

/// Default power preference
const String dsrtDefaultPowerPreference = 'default';

/// Default fail if major performance caveat
const bool dsrtDefaultFailIfMajorPerformanceCaveat = false;

/// Default preserve drawing buffer
const bool dsrtDefaultPreserveDrawingBuffer = false;

/// Default premultiplied alpha
const bool dsrtDefaultPremultipliedAlpha = false;

/// Default antialias
const bool dsrtDefaultAntialias = true;

/// Default alpha
const bool dsrtDefaultAlpha = true;

/// Default depth
const bool dsrtDefaultDepth = true;

/// Default stencil
const bool dsrtDefaultStencil = false;

/// Default desynchronized
const bool dsrtDefaultDesynchronized = false;

/// Default xr compatible
const bool dsrtDefaultXRCompatible = false;
