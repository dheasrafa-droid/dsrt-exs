/// Texture System API for DSRT Engine
/// 
/// Provides texture loading, management, filtering, and procedural
/// generation for material and rendering systems.
/// 
/// [includeCompressed]: Whether to include compressed texture formats.
/// Defaults to true.
library dsrt_engine.public.textures;

// Texture Base Class
export '../src/textures/texture.dart' 
    show Texture, TextureType, TextureState;

// Image Texture
export '../src/textures/image_texture.dart' 
    show ImageTexture, ImageSource, PixelFormat;

// Cube Texture
export '../src/textures/cube_texture.dart' 
    show CubeTexture, CubeFace, CubeMap;

// Video Texture
export '../src/textures/video_texture.dart' 
    show VideoTexture, VideoSource, FrameUpdate;

// Canvas Texture
export '../src/textures/canvas_texture.dart' 
    show CanvasTexture, CanvasSource, CanvasUpdate;

// Compressed Texture
export '../src/textures/compressed_texture.dart' 
    show CompressedTexture, CompressionFormat, Mipmap;

// Texture Loader
export '../src/textures/texture_loader.dart' 
    show TextureLoader, LoadOptions;

// Texture Utilities
export '../src/textures/texture_utils.dart' 
    show TextureUtils, TextureOperations;

// Texture Serialization
export '../src/textures/texture_serializer.dart' 
    show TextureSerializer, TextureData;

// Texture Validation
export '../src/textures/texture_validator.dart' 
    show TextureValidator, TextureValidation;

// Texture Manager
export '../src/textures/texture_manager.dart' 
    show TextureManager, TextureCache;

// Texture Cache
export '../src/textures/texture_cache.dart' 
    show TextureCache, CachePolicy;

// Texture Factory
export '../src/textures/texture_factory.dart' 
    show TextureFactory, FactoryPreset;

// Texture Baking
export '../src/textures/texture_baker.dart' 
    show TextureBaker, BakeOptions;

// Texture Compression
export '../src/textures/texture_compressor.dart' 
    show TextureCompressor, CompressOptions;

// Texture Atlas
export '../src/textures/texture_atlas.dart' 
    show TextureAtlas, AtlasRegion, Packing;

// Texture Packer
export '../src/textures/texture_packer.dart' 
    show TexturePacker, PackOptions;

// Checkerboard Texture Generator
export '../src/textures/generators/checkerboard_texture.dart' 
    show CheckerboardTexture, CheckerPattern;

// Gradient Texture Generator
export '../src/textures/generators/gradient_texture.dart' 
    show GradientTexture, GradientType, ColorStop;

// Noise Texture Generator
export '../src/textures/generators/noise_texture.dart' 
    show NoiseTexture, NoiseType, NoiseParams;

// Voronoi Texture Generator
export '../src/textures/generators/voronoi_texture.dart' 
    show VoronoiTexture, VoronoiCell, DistanceMetric;

// Cellular Texture Generator
export '../src/textures/generators/cellular_texture.dart' 
    show CellularTexture, CellularType, FeaturePoints;

// Data Texture
export '../src/textures/generators/data_texture.dart' 
    show DataTexture, DataFormat, RawData;

// Procedural Texture Generator
export '../src/textures/generators/procedural_texture.dart' 
    show ProceduralTexture, GeneratorFunction;

// Texture Generator Base
export '../src/textures/generators/texture_generator.dart' 
    show TextureGenerator, GenerationOptions;

// PNG Texture Format
export '../src/textures/formats/png_texture.dart' 
    show PNGTexture, PNGDecoder, PNGEncoder;

// JPG Texture Format
export '../src/textures/formats/jpg_texture.dart' 
    show JPGTexture, JPGDecoder, JPGEncoder;

// WebP Texture Format
export '../src/textures/formats/webp_texture.dart' 
    show WebPTexture, WebPDecoder, WebPEncoder;

// KTX Texture Format
export '../src/textures/formats/ktx_texture.dart' 
    show KTXTexture, KTXDecoder, KTXEncoder;

// DDS Texture Format
export '../src/textures/formats/dds_texture.dart' 
    show DDSTexture, DDSDecoder, DDSEncoder;

// PVR Texture Format
export '../src/textures/formats/pvr_texture.dart' 
    show PVRTexture, PVRDecoder, PVREncoder;

// Format Manager
export '../src/textures/formats/format_manager.dart' 
    show FormatManager, FormatRegistry;

// Texture Filter Base
export '../src/textures/filters/texture_filter.dart' 
    show TextureFilter, FilterType;

// Blur Filter
export '../src/textures/filters/blur_filter.dart' 
    show BlurFilter, BlurType, KernelSize;

// Sharpen Filter
export '../src/textures/filters/sharpen_filter.dart' 
    show SharpenFilter, SharpenAmount;

// Edge Detection Filter
export '../src/textures/filters/edge_filter.dart' 
    show EdgeFilter, EdgeDetection, SobelKernel;

// Emboss Filter
export '../src/textures/filters/emboss_filter.dart' 
    show EmbossFilter, EmbossDirection;

// Filter Manager
export '../src/textures/filters/filter_manager.dart' 
    show FilterManager, FilterChain;
