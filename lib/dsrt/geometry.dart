/// Geometry System API for DSRT Engine
/// 
/// Provides geometry creation, manipulation, and optimization for
/// 3D meshes and shapes.
/// 
/// [includeAdvanced]: Whether to include advanced geometry features.
/// Defaults to true.
library dsrt_engine.public.geometry;

// Geometry Base Class
export '../src/geometry/geometry.dart' 
    show Geometry, GeometryType, GeometryData;

// Geometry Attributes
export '../src/geometry/attributes.dart' 
    show Attribute, AttributeType, AttributeData;

// Geometry Utilities
export '../src/geometry/geometry_utils.dart' 
    show GeometryUtils, GeometryOperations;

// Geometry Serialization
export '../src/geometry/geometry_serializer.dart' 
    show GeometrySerializer, GeometryFormat;

// Geometry Validation
export '../src/geometry/geometry_validator.dart' 
    show GeometryValidator, GeometryValidation;

// Geometry Optimization
export '../src/geometry/geometry_optimizer.dart' 
    show GeometryOptimizer, OptimizationResult;

// Geometry Merging
export '../src/geometry/geometry_merger.dart' 
    show GeometryMerger, MergeOptions;

// Geometry Cloning
export '../src/geometry/geometry_cloner.dart' 
    show GeometryCloner, CloneOptions;

// Geometry Calculation
export '../src/geometry/geometry_calculator.dart' 
    show GeometryCalculator, CalculateNormals, CalculateTangents;

// Buffer Geometry
export '../src/geometry/buffer/buffer_geometry.dart' 
    show BufferGeometry, BufferGeometryType;

// Buffer Attribute
export '../src/geometry/buffer/buffer_attribute.dart' 
    show BufferAttribute, AttributeDescriptor;

// Interleaved Buffer
export '../src/geometry/buffer/interleaved_buffer.dart' 
    show InterleavedBuffer, InterleavedFormat;

// Interleaved Buffer Attribute
export '../src/geometry/buffer/interleaved_buffer_attribute.dart' 
    show InterleavedBufferAttribute;

// Instanced Buffer Attribute
export '../src/geometry/buffer/instanced_buffer_attribute.dart' 
    show InstancedBufferAttribute, InstanceData;

// Dynamic Buffer Attribute
export '../src/geometry/buffer/dynamic_buffer_attribute.dart' 
    show DynamicBufferAttribute, DynamicUpdate;

// Attribute Utilities
export '../src/geometry/buffer/attribute_utils.dart' 
    show AttributeUtils, AttributeHelpers;

// Attribute Serialization
export '../src/geometry/buffer/attribute_serializer.dart' 
    show AttributeSerializer, AttributeData;

// Attribute Validation
export '../src/geometry/buffer/attribute_validator.dart' 
    show AttributeValidator, AttributeValidation;

// Buffer Manager
export '../src/geometry/buffer/buffer_manager.dart' 
    show BufferManager, BufferAllocator;

// Box Geometry
export '../src/geometry/primitives/box_geometry.dart' 
    show BoxGeometry, BoxDimensions;

// Sphere Geometry
export '../src/geometry/primitives/sphere_geometry.dart' 
    show SphereGeometry, SphereSegments;

// Cylinder Geometry
export '../src/geometry/primitives/cylinder_geometry.dart' 
    show CylinderGeometry, CylinderParams;

// Cone Geometry
export '../src/geometry/primitives/cone_geometry.dart' 
    show ConeGeometry, ConeParams;

// Torus Geometry
export '../src/geometry/primitives/torus_geometry.dart' 
    show TorusGeometry, TorusParams;

// Plane Geometry
export '../src/geometry/primitives/plane_geometry.dart' 
    show PlaneGeometry, PlaneSegments;

// Ring Geometry
export '../src/geometry/primitives/ring_geometry.dart' 
    show RingGeometry, RingParams;

// Circle Geometry
export '../src/geometry/primitives/circle_geometry.dart' 
    show CircleGeometry, CircleSegments;

// Polyhedron Geometry
export '../src/geometry/primitives/polyhedron_geometry.dart' 
    show PolyhedronGeometry, PolyhedronType;

// Tetrahedron Geometry
export '../src/geometry/primitives/tetrahedron_geometry.dart' 
    show TetrahedronGeometry;

// Octahedron Geometry
export '../src/geometry/primitives/octahedron_geometry.dart' 
    show OctahedronGeometry;

// Dodecahedron Geometry
export '../src/geometry/primitives/dodecahedron_geometry.dart' 
    show DodecahedronGeometry;

// Icosahedron Geometry
export '../src/geometry/primitives/icosahedron_geometry.dart' 
    show IcosahedronGeometry;

// Capsule Geometry
export '../src/geometry/primitives/capsule_geometry.dart' 
    show CapsuleGeometry, CapsuleParams;

// Rounded Box Geometry
export '../src/geometry/primitives/rounded_box_geometry.dart' 
    show RoundedBoxGeometry, RoundingParams;

// Tube Geometry
export '../src/geometry/primitives/tube_geometry.dart' 
    show TubeGeometry, TubeParams;

// Lathe Geometry
export '../src/geometry/primitives/lathe_geometry.dart' 
    show LatheGeometry, LatheParams;

// Primitive Utilities
export '../src/geometry/primitives/primitive_utils.dart' 
    show PrimitiveUtils, PrimitiveGenerator;

// Text Geometry
export '../src/geometry/extras/text_geometry.dart' 
    show TextGeometry, FontData;

// Extrude Geometry
export '../src/geometry/extras/extrude_geometry.dart' 
    show ExtrudeGeometry, ExtrudeSettings;

// Parametric Geometry
export '../src/geometry/extras/parametric_geometry.dart' 
    show ParametricGeometry, ParametricFunction;

// Wireframe Geometry
export '../src/geometry/extras/wireframe_geometry.dart' 
    show WireframeGeometry, WireframeOptions;

// Edges Geometry
export '../src/geometry/extras/edges_geometry.dart' 
    show EdgesGeometry, EdgeDetection;

// Convex Geometry
export '../src/geometry/extras/convex_geometry.dart' 
    show ConvexGeometry, ConvexHull;

// Decal Geometry
export '../src/geometry/extras/decal_geometry.dart' 
    show DecalGeometry, DecalProjection;

// Explode Geometry
export '../src/geometry/extras/explode_geometry.dart' 
    show ExplodeGeometry, ExplodeOptions;

// Extra Geometry Utilities
export '../src/geometry/extras/extra_utils.dart' 
    show ExtraGeometryUtils;

// Shape Base Class
export '../src/geometry/shapes/shape.dart' 
    show Shape, ShapeType;

// Shape Path
export '../src/geometry/shapes/shape_path.dart' 
    show ShapePath, PathCommand;

// Shape Utilities
export '../src/geometry/shapes/shape_utils.dart' 
    show ShapeUtils, ShapeOperations;

// Shape Serialization
export '../src/geometry/shapes/shape_serializer.dart' 
    show ShapeSerializer, ShapeData;

// Shape Validation
export '../src/geometry/shapes/shape_validator.dart' 
    show ShapeValidator, ShapeValidation;

// Subdivision Modifier
export '../src/geometry/modifiers/subdivision_modifier.dart' 
    show SubdivisionModifier, SubdivisionScheme;

// Tessellation Modifier
export '../src/geometry/modifiers/tessellation_modifier.dart' 
    show TessellationModifier, TessellationLevel;

// Smooth Modifier
export '../src/geometry/modifiers/smooth_modifier.dart' 
    show SmoothModifier, SmoothingIterations;

// Explode Modifier
export '../src/geometry/modifiers/explode_modifier.dart' 
    show ExplodeModifier, ExplodeBy;

// Simplify Modifier
export '../src/geometry/modifiers/simplify_modifier.dart' 
    show SimplifyModifier, SimplifyTarget;

// Subdivision Surface
export '../src/geometry/modifiers/subdivision_surface.dart' 
    show SubdivisionSurface, SubdivisionResult;

// Modifier Manager
export '../src/geometry/modifiers/modifier_manager.dart' 
    show ModifierManager, ModifierStack;

// LOD Geometry
export '../src/geometry/lod/lod_geometry.dart' 
    show LODGeometry, LODLevel;

// LOD Generator
export '../src/geometry/lod/lod_generator.dart' 
    show LODGenerator, LODOptions;

// LOD Manager
export '../src/geometry/lod/lod_manager.dart' 
    show LODManager, LODSystem;

// LOD Utilities
export '../src/geometry/lod/lod_utils.dart' 
    show LODUtils, LODHelpers;
