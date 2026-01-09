/// Public Interfaces for DSRT Engine
/// 
/// Provides abstract classes and interfaces that define contracts
/// for engine components and extension points.
/// 
/// [includeAll]: Whether to include all interfaces.
/// Defaults to true.
library dsrt_engine.public.interfaces;

// Engine Interfaces
export '../src/core/engine.dart' 
    show
    IEngine,
    IEngineLifecycle,
    IEngineEvents;

// Renderer Interfaces
export '../src/renderer/renderer.dart' 
    show
    IRenderer,
    IRenderContext,
    IRenderPipeline;

// Scene Interfaces
export '../src/scene/scene.dart' 
    show
    IScene,
    ISceneObject,
    ISceneGraph;

export '../src/scene/object_3d.dart' 
    show
    ITransformable,
    IUpdatable,
    IDisposable;

// Camera Interfaces
export '../src/camera/camera.dart' 
    show
    ICamera,
    IProjection,
    ICameraControls;

// Material Interfaces
export '../src/materials/material.dart' 
    show
    IMaterial,
    IShaderMaterial,
    IUniformContainer;

// Geometry Interfaces
export '../src/geometry/geometry.dart' 
    show
    IGeometry,
    IBufferGeometry,
    IAttributeContainer;

// Light Interfaces
export '../src/lights/light.dart' 
    show
    ILight,
    IShadowCaster,
    IShadowReceiver;

// Texture Interfaces
export '../src/textures/texture.dart' 
    show
    ITexture,
    ILoadableTexture,
    IProceduralTexture;

// Loader Interfaces
export '../src/loaders/loader.dart' 
    show
    ILoader,
    IAsyncLoader,
    IProgressLoader;

// Animation Interfaces
export '../src/animation/animation_clip.dart' 
    show
    IAnimationClip,
    IKeyframeTrack,
    IAnimatable;

export '../src/animation/animation_mixer.dart' 
    show
    IAnimationMixer,
    IAnimationController,
    IBlendTree;

// Physics Interfaces
export '../src/physics/world.dart' 
    show
    IPhysicsWorld,
    IRigidBody,
    ICollider;

export '../src/physics/collision/collision_system.dart' 
    show
    ICollisionShape,
    IConstraint,
    IContactListener;

// Audio Interfaces
export '../src/audio/audio_context.dart' 
    show
    IAudioContext,
    IAudioNode,
    IAudioParam;

export '../src/audio/audio_source.dart' 
    show
    IAudioSource,
    IPositionalAudio,
    IAudioBuffer;

// UI Interfaces
export '../src/ui/ui_element.dart' 
    show
    IUIElement,
    ILayoutElement,
    IInteractiveElement;

export '../src/ui/ui_manager.dart' 
    show
    IUIManager,
    ICanvasRenderer,
    ITextRenderer;

// Plugin Interfaces
export '../src/plugins/plugin_manager.dart' 
    show
    IPlugin,
    IPluginManager,
    IPluginRegistry;

// Event Interfaces
export '../src/core/events/event_system.dart' 
    show
    IEventSystem,
    IEventEmitter,
    IEventListener;

// Resource Interfaces
export '../src/core/utils/resource_utils.dart' 
    show
    IResource,
    IResourceLoader,
    IResourceCache;

// Serialization Interfaces
export '../src/core/utils/serialization_utils.dart' 
    show
    ISerializable,
    IDeserializable,
    ISerializer;

// Factory Interfaces
export '../src/core/utils/factory_utils.dart' 
    show
    IFactory,
    IRegistry,
    IPrototype;

// Pool Interfaces
export '../src/core/utils/pool_utils.dart' 
    show
    IPool,
    IObjectPool,
    IPoolable;

// Observable Interfaces
export '../src/core/utils/observable_utils.dart' 
    show
    IObservable,
    IObserver,
    ISubject;

// Command Interfaces
export '../src/core/utils/command_utils.dart' 
    show
    ICommand,
    ICommandExecutor,
    IUndoRedoStack;

// State Machine Interfaces
export '../src/core/utils/state_machine.dart' 
    show
    IState,
    IStateMachine,
    ITransition;

// Service Interfaces
export '../src/core/utils/service_locator.dart' 
    show
    IService,
    IServiceLocator,
    IServiceProvider;

// Configurable Interfaces
export '../src/core/utils/configurable.dart' 
    show
    IConfigurable,
    IConfiguration,
    ISettingsProvider;

// Validatable Interfaces
export '../src/core/utils/validatable.dart' 
    show
    IValidatable,
    IValidator,
    IValidationResult;

// Cloneable Interfaces
export '../src/core/utils/cloneable.dart' 
    show
    ICloneable,
    IDeepCloneable,
    IShallowCloneable;

// Comparable Interfaces
export '../src/core/utils/comparable.dart' 
    show
    IComparable,
    IEquatable,
    IHashable;

// Debug Interfaces
export '../src/core/utils/debug_utils.dart' 
    show
    IDebuggable,
    IDebugVisualizer,
    IProfiler;

// Extension Interfaces
export '../src/core/utils/extension_utils.dart' 
    show
    IExtensible,
    IExtension,
    IExtensionPoint;
