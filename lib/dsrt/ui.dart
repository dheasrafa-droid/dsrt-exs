/// User Interface API for DSRT Engine
/// 
/// Provides 2D UI elements, layout systems, input handling,
/// and overlay rendering for games and applications.
/// 
/// [includeOverlays]: Whether to include VR/AR overlay features.
/// Defaults to true.
library dsrt_engine.public.ui;

// UI Manager
export '../src/ui/ui_manager.dart' 
    show UIManager, ManagerState, RenderMode;

// Canvas 2D Renderer
export '../src/ui/canvas_2d.dart' 
    show Canvas2D, CanvasContext, DrawingAPI;

// Text Renderer
export '../src/ui/text_renderer.dart' 
    show TextRenderer, FontAtlas, GlyphRendering;

// UI Element Base Class
export '../src/ui/ui_element.dart' 
    show UIElement, ElementType, ElementState;

// Button Element
export '../src/ui/button.dart' 
    show Button, ButtonState, ClickHandler;

// Panel Element (Container)
export '../src/ui/panel.dart' 
    show Panel, LayoutContainer, Background;

// UI Utilities
export '../src/ui/ui_utils.dart' 
    show UIUtils, UIHelpers;

// UI Serialization
export '../src/ui/ui_serializer.dart' 
    show UISerializer, UIData;

// UI Validation
export '../src/ui/ui_validator.dart' 
    show UIValidator, UIValidation;

// UI Configuration
export '../src/ui/ui_config.dart' 
    show UIConfig, RenderSettings;

// UI Debugging
export '../src/ui/ui_debug.dart' 
    show UIDebug, DebugOverlay;

// UI Layout System
export '../src/ui/layout/ui_layout.dart' 
    show UILayout, LayoutEngine, ConstraintSystem;

// Flex Layout
export '../src/ui/layout/flex_layout.dart' 
    show FlexLayout, FlexDirection, JustifyContent;

// Grid Layout
export '../src/ui/layout/grid_layout.dart' 
    show GridLayout, GridTemplate, GridArea;

// Stack Layout
export '../src/ui/layout/stack_layout.dart' 
    show StackLayout, ZIndex, StackingContext;

// Layout Utilities
export '../src/ui/layout/layout_utils.dart' 
    show LayoutUtils, LayoutHelpers;

// Layout Manager
export '../src/ui/layout/layout_manager.dart' 
    show LayoutManager, LayoutSystem;

// Slider Component
export '../src/ui/components/slider.dart' 
    show Slider, RangeInput, ValueChange;

// Dropdown Component
export '../src/ui/components/dropdown.dart' 
    show Dropdown, SelectOption, MenuList;

// Color Picker
export '../src/ui/components/color_picker.dart' 
    show ColorPicker, ColorSpace, Palette;

// Checkbox Component
export '../src/ui/components/checkbox.dart' 
    show Checkbox, ToggleState, CheckboxGroup;

// Radio Button
export '../src/ui/components/radio_button.dart' 
    show RadioButton, RadioGroup, Selection;

// Text Field
export '../src/ui/components/text_field.dart' 
    show TextField, InputType, Validation;

// Label Component
export '../src/ui/components/label.dart' 
    show Label, TextContent, Styling;

// Image Component
export '../src/ui/components/image.dart' 
    show UIImage, ImageSource, Scaling;

// Progress Bar
export '../src/ui/components/progress_bar.dart' 
    show ProgressBar, ProgressValue, Animation;

// Scroll View
export '../src/ui/components/scroll_view.dart' 
    show ScrollView, ScrollDirection, Scrollbar;

// Tab View
export '../src/ui/components/tab_view.dart' 
    show TabView, TabContainer, TabHeader;

// List View
export '../src/ui/components/list_view.dart' 
    show ListView, ListItem, VirtualScroll;

// Tree View
export '../src/ui/components/tree_view.dart' 
    show TreeView, TreeNode, ExpandCollapse;

// Menu Component
export '../src/ui/components/menu.dart' 
    show Menu, MenuItem, Submenu;

// Toolbar Component
export '../src/ui/components/toolbar.dart' 
    show Toolbar, ToolItem, Separator;

// Status Bar
export '../src/ui/components/status_bar.dart' 
    show StatusBar, StatusItem, Notification;

// Component Manager
export '../src/ui/components/component_manager.dart' 
    show ComponentManager, RegistrySystem;

// DOM Overlay (HTML Integration)
export '../src/ui/overlays/dom_overlay.dart' 
    show DOMOverlay, HTMLElement, CSSStyling;

// Canvas Overlay
export '../src/ui/overlays/canvas_overlay.dart' 
    show CanvasOverlay, OverlayCanvas, Compositing;

// VR Overlay
export '../src/ui/overlays/vr_overlay.dart' 
    show VROverlay, VRDisplay, ControllerUI;

// AR Overlay
export '../src/ui/overlays/ar_overlay.dart' 
    show AROverlay, ARSession, WorldUI;

// Overlay Manager
export '../src/ui/overlays/overlay_manager.dart' 
    show OverlayManager, OverlaySystem;

// UI Theme System
export '../src/ui/themes/ui_theme.dart' 
    show UITheme, ThemeData, StyleSheet;

// Dark Theme
export '../src/ui/themes/dark_theme.dart' 
    show DarkTheme, DarkPalette, ContrastRatios;

// Light Theme
export '../src/ui/themes/light_theme.dart' 
    show LightTheme, LightPalette, Brightness;

// Theme Manager
export '../src/ui/themes/theme_manager.dart' 
    show ThemeManager, ThemeSwitcher;

// Theme Serialization
export '../src/ui/themes/theme_serializer.dart' 
    show ThemeSerializer, ThemeData;
