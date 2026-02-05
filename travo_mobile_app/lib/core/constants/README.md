# Travo App Design System

## Color Palette

This document outlines the color system used throughout the Travo mobile application.

### File Structure

```
lib/
  core/
    constants/
      app_colors.dart    # All color definitions
      app_theme.dart     # Complete theme configuration
      constants.dart     # Barrel file for easy imports
```

### Usage

Import the colors in your Dart files:

```dart
import 'package:travo_mobile_app/core/constants/app_colors.dart';

// Or import everything at once
import 'package:travo_mobile_app/core/constants/constants.dart';
```

Use the colors in your widgets:

```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textOnPrimary),
  ),
)
```

### Color Categories

#### Primary Colors
- `AppColors.primary` - Deep teal (#0A445A) - Main brand color
- `AppColors.primaryVariant` - Teal (#009688) - Variant for variety
- `AppColors.accent` - Coral (#FF7D62) - Accent/highlight color
- `AppColors.secondary` - Light coral (#FF9580) - Secondary accent

#### Background Colors
- `AppColors.background` - White (#FFFFFF) - Main background
- `AppColors.surface` - White (#FFFFFF) - Cards and elevated elements
- `AppColors.surfaceLight` - Light grey (#F5F5F5) - Subtle backgrounds

#### Text Colors
- `AppColors.textPrimary` - Dark slate (#1E293B) - Primary text
- `AppColors.textSecondary` - Grey (#64748B) - Secondary text
- `AppColors.textDisabled` - Light grey (#94A3B8) - Disabled text
- `AppColors.textOnPrimary` - White (#FFFFFF) - Text on primary background
- `AppColors.textOnAccent` - White (#FFFFFF) - Text on accent background

#### UI Element Colors
- `AppColors.border` - Light grey (#E2E8F0) - Borders
- `AppColors.divider` - Grey (#CBD5E1) - Dividers
- `AppColors.inputFill` - Very light grey (#F1F5F9) - Input backgrounds
- `AppColors.shadow` - Transparent black (#1A000000) - Shadows

#### Status Colors
- `AppColors.success` - Green (#10B981) - Success states
- `AppColors.warning` - Orange (#F59E0B) - Warning states
- `AppColors.error` - Red (#EF4444) - Error states
- `AppColors.info` - Blue (#3B82F6) - Info states

#### Transparent Variations
- `AppColors.primaryLight10` - Primary at 10% opacity
- `AppColors.primaryLight20` - Primary at 20% opacity
- `AppColors.primaryLight50` - Primary at 50% opacity
- `AppColors.accentLight10` - Accent at 10% opacity
- `AppColors.accentLight20` - Accent at 20% opacity
- `AppColors.blackLight10` - Black at 10% opacity
- `AppColors.blackLight20` - Black at 20% opacity
- `AppColors.whiteLight90` - White at 90% opacity

#### Gradients
- `AppColors.primaryGradient` - Primary gradient (primary → primaryVariant)
- `AppColors.accentGradient` - Accent gradient (accent → secondary)
- `AppColors.backgroundGradient` - Subtle background gradient

### Theme Configuration

The app uses a comprehensive theme configuration in `app_theme.dart` that includes:

- Color scheme
- Typography (text styles)
- Button styles (Elevated, Outlined, Text buttons)
- Input field styling
- App bar styling
- Card styling
- Bottom navigation bar styling
- Icon theme
- Divider theme

To use the theme:

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  // ...
)
```

### Best Practices

1. **Always use AppColors** - Never use hardcoded colors directly
2. **Use semantic names** - Reference colors by their purpose (e.g., `textPrimary`) not their appearance
3. **Consistent opacity** - Use predefined opacity variations instead of creating new ones
4. **Theme inheritance** - Prefer using `Theme.of(context)` where possible
5. **Accessibility** - Ensure sufficient contrast between text and backgrounds

### Example Components

#### Button with Primary Color
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
  ),
  child: Text('Click Me'),
)
```

#### Card with Shadow
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: // ...
)
```

#### Input Field
```dart
TextField(
  decoration: InputDecoration(
    filled: true,
    fillColor: AppColors.inputFill,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  ),
)
```

### Color Palette Visual Reference

```
Primary Colors:
■ #0A445A  Deep Teal (primary)
■ #009688  Teal (primaryVariant)
■ #FF7D62  Coral (accent)
■ #FF9580  Light Coral (secondary)

Neutral Colors:
□ #FFFFFF  White (background, surface)
□ #F5F5F9  Very Light Grey (surfaceLight)
□ #F1F5F9  Light Grey (inputFill)
□ #E2E8F0  Grey (border)
□ #CBD5E1  Medium Grey (divider)
□ #94A3B8  Grey Blue (textDisabled)
□ #64748B  Slate Grey (textSecondary)
■ #1E293B  Dark Slate (textPrimary)

Status Colors:
■ #10B981  Green (success)
■ #F59E0B  Orange (warning)
■ #EF4444  Red (error)
■ #3B82F6  Blue (info)
```

### Maintenance

When adding new colors:
1. Add them to `app_colors.dart` in the appropriate section
2. Update this README with the new color documentation
3. Consider if the theme in `app_theme.dart` needs updating
4. Test the color in both light and dark contexts (for future dark mode support)

---

**Last Updated:** February 2026
**Maintained by:** Travo Development Team
