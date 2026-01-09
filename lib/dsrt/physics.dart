/// Physics System API for DSRT Engine
/// 
/// Provides rigid body dynamics, collision detection, constraints,
/// soft bodies, and vehicle physics simulation.
/// 
/// [includeSoftBody]: Whether to include soft body physics.
/// Defaults to true.
library dsrt_engine.public.physics;

// Physics World
export '../src/physics/world.dart' 
    show PhysicsWorld, WorldType, WorldState;

// Rigid Body
export '../src/physics/rigid_body.dart' 
    show RigidBody, BodyType, BodyState;

// Collider
export '../src/physics/collider.dart' 
    show Collider, ColliderType, CollisionShape;

// Physics Utilities
export '../src/physics/physics_utils.dart' 
    show PhysicsUtils, PhysicsHelpers;

// Physics Serialization
export '../src/physics/physics_serializer.dart' 
    show PhysicsSerializer, PhysicsData;

// Physics Validation
export '../src/physics/physics_validator.dart' 
    show PhysicsValidator, PhysicsValidation;

// Physics Manager
export '../src/physics/physics_manager.dart' 
    show PhysicsManager, SimulationSystem;

// Physics Configuration
export '../src/physics/physics_config.dart' 
    show PhysicsConfig, SimulatorSettings;

// Physics Debugging
export '../src/physics/physics_debug.dart' 
    show PhysicsDebug, DebugRenderer;

// Physics Profiling
export '../src/physics/physics_profiler.dart' 
    show PhysicsProfiler, PerformanceMetrics;

// Collision System
export '../src/physics/collision/collision_system.dart' 
    show CollisionSystem, DetectionAlgorithm;

// Broad Phase
export '../src/physics/collision/broad_phase.dart' 
    show BroadPhase, BVH, SweepAndPrune;

// Narrow Phase
export '../src/physics/collision/narrow_phase.dart' 
    show NarrowPhase, ContactGeneration;

// Collision Utilities
export '../src/physics/collision/collision_utils.dart' 
    show CollisionUtils, CollisionHelpers;

// Collision Manager
export '../src/physics/collision/collision_manager.dart' 
    show CollisionManager, ContactSystem;

// Collision Detection
export '../src/physics/collision/collision_detection.dart' 
    show CollisionDetection, DetectionResult;

// Collision Resolution
export '../src/physics/collision/collision_resolution.dart' 
    show CollisionResolution, ContactSolver;

// Collision Response
export '../src/physics/collision/collision_response.dart' 
    show CollisionResponse, ImpulseCalculation;

// Collision Debugging
export '../src/physics/collision/collision_debug.dart' 
    show CollisionDebug, ContactVisualization;

// Box Collision Shape
export '../src/physics/collision/collision_shapes/box_shape.dart' 
    show BoxShape, BoxDimensions;

// Sphere Collision Shape
export '../src/physics/collision/collision_shapes/sphere_shape.dart' 
    show SphereShape, SphereRadius;

// Mesh Collision Shape
export '../src/physics/collision/collision_shapes/mesh_shape.dart' 
    show MeshShape, TriangleMesh, ConvexHull;

// Capsule Collision Shape
export '../src/physics/collision/collision_shapes/capsule_shape.dart' 
    show CapsuleShape, CapsuleDimensions;

// Cylinder Collision Shape
export '../src/physics/collision/collision_shapes/cylinder_shape.dart' 
    show CylinderShape, CylinderDimensions;

// Cone Collision Shape
export '../src/physics/collision/collision_shapes/cone_shape.dart' 
    show ConeShape, ConeDimensions;

// Convex Collision Shape
export '../src/physics/collision/collision_shapes/convex_shape.dart' 
    show ConvexShape, ConvexPolyhedron;

// Heightfield Collision Shape
export '../src/physics/collision/collision_shapes/heightfield_shape.dart' 
    show HeightfieldShape, HeightData, TerrainCollision;

// Compound Collision Shape
export '../src/physics/collision/collision_shapes/compound_shape.dart' 
    show CompoundShape, ChildShape, TransformOffset;

// Static Plane Shape
export '../src/physics/collision/collision_shapes/static_plane_shape.dart' 
    show StaticPlaneShape, PlaneNormal, PlaneConstant;

// Shape Utilities
export '../src/physics/collision/collision_shapes/shape_utils.dart' 
    show ShapeUtils, ShapeOperations;

// Shape Serialization
export '../src/physics/collision/collision_shapes/shape_serializer.dart' 
    show ShapeSerializer, ShapeData;

// Shape Validation
export '../src/physics/collision/collision_shapes/shape_validator.dart' 
    show ShapeValidator, ShapeValidation;

// Constraint Base Class
export '../src/physics/constraints/constraint.dart' 
    show Constraint, ConstraintType;

// Hinge Constraint
export '../src/physics/constraints/hinge_constraint.dart' 
    show HingeConstraint, HingeAxis, LimitMotor;

// Point Constraint (Ball Joint)
export '../src/physics/constraints/point_constraint.dart' 
    show PointConstraint, PivotPoint;

// Slider Constraint
export '../src/physics/constraints/slider_constraint.dart' 
    show SliderConstraint, SliderAxis, LinearLimit;

// Cone Twist Constraint
export '../src/physics/constraints/cone_twist_constraint.dart' 
    show ConeTwistConstraint, SwingTwistLimit;

// Fixed Constraint
export '../src/physics/constraints/fixed_constraint.dart' 
    show FixedConstraint, RigidAttachment;

// Constraint Utilities
export '../src/physics/constraints/constraint_utils.dart' 
    show ConstraintUtils, ConstraintHelpers;

// Constraint Manager
export '../src/physics/constraints/constraint_manager.dart' 
    show ConstraintManager, SolverSystem;

// Constraint Serialization
export '../src/physics/constraints/constraint_serializer.dart' 
    show ConstraintSerializer, ConstraintData;

// Constraint Validation
export '../src/physics/constraints/constraint_validator.dart' 
    show ConstraintValidator, ConstraintValidation;

// Euler Integrator
export '../src/physics/integrators/euler_integrator.dart' 
    show EulerIntegrator, ExplicitEuler, SemiImplicitEuler;

// Verlet Integrator
export '../src/physics/integrators/verlet_integrator.dart' 
    show VerletIntegrator, VerletIntegration;

// Runge-Kutta Integrator
export '../src/physics/integrators/runge_kutta_integrator.dart' 
    show RungeKuttaIntegrator, RK4Method;

// Symplectic Integrator
export '../src/physics/integrators/symplectic_integrator.dart' 
    show SymplecticIntegrator, LeapfrogMethod;

// Integrator Utilities
export '../src/physics/integrators/integrator_utils.dart' 
    show IntegratorUtils, IntegrationHelpers;

// Integrator Manager
export '../src/physics/integrators/integrator_manager.dart' 
    show IntegratorManager, IntegrationSystem;

// Soft Body Simulation
export '../src/physics/soft_body/soft_body.dart' 
    show SoftBody, SoftBodyType, MassSpringSystem;

// Cloth Simulation
export '../src/physics/soft_body/cloth_simulation.dart' 
    show ClothSimulation, ClothMesh, Stiffness;

// Soft Body Utilities
export '../src/physics/soft_body/soft_body_utils.dart' 
    show SoftBodyUtils, SoftBodyHelpers;

// Soft Body Manager
export '../src/physics/soft_body/soft_body_manager.dart' 
    show SoftBodyManager, SimulationSystem;

// Fluid Simulation
export '../src/physics/fluids/fluid_simulation.dart' 
    show FluidSimulation, SPHMethod, GridBased;

// Fluid Particles
export '../src/physics/fluids/fluid_particles.dart' 
    show FluidParticles, ParticleSystem, Density;

// Fluid Solver
export '../src/physics/fluids/fluid_solver.dart' 
    show FluidSolver, NavierStokes, PressureSolve;

// Fluid Manager
export '../src/physics/fluids/fluid_manager.dart' 
    show FluidManager, FluidSystem;

// Vehicle Physics
export '../src/physics/vehicles/vehicle.dart' 
    show Vehicle, VehicleType, Chassis;

// Wheel System
export '../src/physics/vehicles/wheel.dart' 
    show Wheel, WheelType, Suspension;

// Vehicle Controller
export '../src/physics/vehicles/vehicle_controller.dart' 
    show VehicleController, DrivingModel;

// Vehicle Manager
export '../src/physics/vehicles/vehicle_manager.dart' 
    show VehicleManager, VehicleSystem;

// Character Controller
export '../src/physics/characters/character_controller.dart' 
    show CharacterController, CapsuleController;

// Character Movement
export '../src/physics/characters/character_movement.dart' 
    show CharacterMovement, MovementState;

// Character Manager
export '../src/physics/characters/character_manager.dart' 
    show CharacterManager, CharacterSystem;

// Ragdoll Simulation
export '../src/physics/ragdolls/ragdoll.dart' 
    show Ragdoll, RagdollType, SkeletonRagdoll;

// Ragdoll Joint
export '../src/physics/ragdolls/ragdoll_joint.dart' 
    show RagdollJoint, JointConstraint;

// Ragdoll Manager
export '../src/physics/ragdolls/ragdoll_manager.dart' 
    show RagdollManager, RagdollSystem;
