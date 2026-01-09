/// Scene Graph API for DSRT Engine
/// 
/// Provides scene management, object hierarchy, raycasting, and
/// spatial partitioning systems.
/// 
/// [includeSpatial]: Whether to include spatial partitioning systems.
/// Defaults to true.
library dsrt_engine.public.scene;

// Scene Container
export '../src/scene/scene.dart' 
    show Scene, SceneState, SceneOptions;

// 3D Object Base Class
export '../src/scene/object_3d.dart' 
    show Object3D, Object3DType, Object3DState;

// Object Grouping
export '../src/scene/group.dart' 
    show Group;

// Object Layers
export '../src/scene/layers.dart' 
    show Layers, LayerMask;

// View Frustum
export '../src/scene/frustum.dart' 
    show Frustum, FrustumTest;

// Scene Graph Management
export '../src/scene/scene_graph.dart' 
    show SceneGraph, GraphNode, GraphTraversal;

// Scene Utilities
export '../src/scene/scene_utils.dart' 
    show SceneUtils, SceneTraversal;

// Scene Serialization
export '../src/scene/scene_serializer.dart' 
    show SceneSerializer, SceneFormat;

// Scene Export
export '../src/scene/scene_exporter.dart' 
    show SceneExporter, ExportOptions;

// Scene Import
export '../src/scene/scene_importer.dart' 
    show SceneImporter, ImportOptions;

// Scene Validation
export '../src/scene/scene_validator.dart' 
    show SceneValidator, ValidationResult;

// Scene Optimization
export '../src/scene/scene_optimizer.dart' 
    show SceneOptimizer, OptimizationLevel;

// Raycasting System
export '../src/scene/raycaster.dart' 
    show Raycaster, RaycastOptions;

// Raycast Hit Result
export '../src/scene/raycast_hit.dart' 
    show RaycastHit, HitInfo;

// Raycast Result Set
export '../src/scene/raycast_result.dart' 
    show RaycastResult, HitCollection;

// Intersectable Interface
export '../src/scene/intersectable.dart' 
    show Intersectable, IntersectionTest;

// Intersection Testing
export '../src/scene/intersection_test.dart' 
    show IntersectionTest, IntersectionType;

// Object Picking
export '../src/scene/picker.dart' 
    show Picker, PickResult;

// Parent-Child Relationships
export '../src/scene/hierarchy/parent_child.dart' 
    show ParentChild, HierarchyTransform;

// Transform Graph
export '../src/scene/hierarchy/transform_graph.dart' 
    show TransformGraph, TransformNode;

// Hierarchy Utilities
export '../src/scene/hierarchy/hierarchy_utils.dart' 
    show HierarchyUtils, TransformUpdate;

// Hierarchy Serialization
export '../src/scene/hierarchy/hierarchy_serializer.dart' 
    show HierarchySerializer;

// Hierarchy Validation
export '../src/scene/hierarchy/hierarchy_validator.dart' 
    show HierarchyValidator;

// Culling System Base
export '../src/scene/culling/culler.dart' 
    show Culler, CullingTest;

// Frustum Culling
export '../src/scene/culling/frustum_culler.dart' 
    show FrustumCuller, FrustumCullingResult;

// Occlusion Culling
export '../src/scene/culling/occlusion_culler.dart' 
    show OcclusionCuller, OcclusionQuery;

// Distance Culling
export '../src/scene/culling/distance_culler.dart' 
    show DistanceCuller, DistanceThreshold;

// LOD Culling
export '../src/scene/culling/lod_culler.dart' 
    show LODCuller, LODLevel;

// Culling Utilities
export '../src/scene/culling/culling_utils.dart' 
    show CullingUtils, CullingStats;

// Culling Manager
export '../src/scene/culling/culling_manager.dart' 
    show CullingManager, CullingStrategy;

// Constraint Base Class
export '../src/scene/constraints/constraint.dart' 
    show Constraint, ConstraintType;

// Transform Constraint
export '../src/scene/constraints/transform_constraint.dart' 
    show TransformConstraint, TransformLimit;

// Look-At Constraint
export '../src/scene/constraints/look_at_constraint.dart' 
    show LookAtConstraint, LookAtTarget;

// Position Constraint
export '../src/scene/constraints/position_constraint.dart' 
    show PositionConstraint, PositionLimit;

// Rotation Constraint
export '../src/scene/constraints/rotation_constraint.dart' 
    show RotationConstraint, RotationLimit;

// Scale Constraint
export '../src/scene/constraints/scale_constraint.dart' 
    show ScaleConstraint, ScaleLimit;

// Parent Constraint
export '../src/scene/constraints/parent_constraint.dart' 
    show ParentConstraint, ParentSpace;

// Aim Constraint
export '../src/scene/constraints/aim_constraint.dart' 
    show AimConstraint, AimVector;

// Constraint Manager
export '../src/scene/constraints/constraint_manager.dart' 
    show ConstraintManager, ConstraintSolver;

// Interactable Interface
export '../src/scene/interaction/interactable.dart' 
    show Interactable, InteractionType;

// Interaction Manager
export '../src/scene/interaction/interaction_manager.dart' 
    show InteractionManager, InteractionState;

// Pointer Handler
export '../src/scene/interaction/pointer_handler.dart' 
    show PointerHandler, PointerEvent;

// Drag Handler
export '../src/scene/interaction/drag_handler.dart' 
    show DragHandler, DragEvent;

// Hover Handler
export '../src/scene/interaction/hover_handler.dart' 
    show HoverHandler, HoverEvent;

// Click Handler
export '../src/scene/interaction/click_handler.dart' 
    show ClickHandler, ClickEvent;

// Interaction Utilities
export '../src/scene/interaction/interaction_utils.dart' 
    show InteractionUtils, InteractionHelpers;

// Spatial Index Interface
export '../src/scene/spatial/spatial_index.dart' 
    show SpatialIndex, SpatialQuery;

// Spatial Partitioning
export '../src/scene/spatial/spatial_partition.dart' 
    show SpatialPartition, PartitionType;

// Grid Partitioning
export '../src/scene/spatial/grid_partition.dart' 
    show GridPartition, GridCell;

// Quadtree
export '../src/scene/spatial/quadtree.dart' 
    show Quadtree, QuadtreeNode;

// Octree
export '../src/scene/spatial/octree.dart' 
    show Octree, OctreeNode;

// Spatial Query System
export '../src/scene/spatial/spatial_query.dart' 
    show SpatialQuery, QueryResult;
