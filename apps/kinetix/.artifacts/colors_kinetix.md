---
name: Tactile Velour
colors:
  surface: '#fff8f7'
  surface-dim: '#e8d6d8'
  surface-bright: '#fff8f7'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff0f1'
  surface-container: '#fde9ec'
  surface-container-high: '#f7e4e6'
  surface-container-highest: '#f1dee0'
  on-surface: '#23191b'
  on-surface-variant: '#554245'
  inverse-surface: '#392e2f'
  inverse-on-surface: '#ffecee'
  outline: '#887175'
  outline-variant: '#dbc0c4'
  surface-tint: '#a13a58'
  primary: '#9e3756'
  on-primary: '#ffffff'
  primary-container: '#bd506e'
  on-primary-container: '#fffbff'
  inverse-primary: '#ffb1c2'
  secondary: '#8d4a52'
  on-secondary: '#ffffff'
  secondary-container: '#ffaab2'
  on-secondary-container: '#7b3b43'
  tertiary: '#6b5753'
  on-tertiary: '#ffffff'
  tertiary-container: '#85706b'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffd9df'
  primary-fixed-dim: '#ffb1c2'
  on-primary-fixed: '#3f0018'
  on-primary-fixed-variant: '#822141'
  secondary-fixed: '#ffdadc'
  secondary-fixed-dim: '#ffb2b9'
  on-secondary-fixed: '#3a0812'
  on-secondary-fixed-variant: '#71333c'
  tertiary-fixed: '#f8dcd7'
  tertiary-fixed-dim: '#dbc1bc'
  on-tertiary-fixed: '#261815'
  on-tertiary-fixed-variant: '#55423f'
  background: '#fff8f7'
  on-background: '#23191b'
  surface-variant: '#f1dee0'
typography:
  display-lg:
    fontFamily: Montserrat
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Montserrat
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
  headline-md:
    fontFamily: Montserrat
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base-unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  container-margin: 20px
  gutter: 16px
---

## Brand & Style
The design system for this premium sports e-commerce app prioritizes a "Tactile-Lux" aesthetic. It targets an affluent, fitness-conscious demographic that values both performance and high-fashion aesthetics. The UI balances the physical, organic feel of Neumorphism with the digital lightness of Glassmorphism.

The visual narrative is "Soft Power." By combining the grounded, extruded surfaces of the beige base with ethereal, frosted overlays, the system creates an environment that feels both sturdy (sporty) and sophisticated (premium). The emotional response should be one of comfort, high-end quality, and kinetic energy.

## Colors
This design system utilizes a warm, monochromatic-adjacent palette to maintain a premium feel. 

- **Primary (#D76483):** Used for key actions, brand moments, and energetic accents.
- **Secondary & Accent:** Provide soft transitions and tonal depth for category labels and secondary information.
- **Base (#F6E5CB):** The foundational canvas. All neumorphic shadows and highlights must be calculated relative to this specific beige hex to ensure the "extruded" effect remains convincing and clean.

## Typography
The typography strategy pairings the assertive, geometric nature of Montserrat for headlines with the utilitarian precision of Inter for functional text. 

High-contrast weight distribution is essential: headers should be heavy (700+) to evoke "sport," while body text remains light and airy to maintain the "premium" feel. Use uppercase tracking for labels to create a sense of organized, high-end cataloging.

## Layout & Spacing
This system follows a fluid mobile-first grid. Given the tactile nature of the components (which require larger tap targets and shadow breathing room), the spacing is generous.

- **Grid:** 4-column mobile grid with 20px outside margins.
- **Padding:** Elements should use a minimum of 16px internal padding to ensure neumorphic "pushed" or "raised" states don't feel cramped. 
- **Rhythm:** Vertical rhythm follows an 8px scale. Large sections (e.g., product categories) are separated by 32px to allow the shadows to feather naturally without overlapping.

## Elevation & Depth
Depth is the core differentiator of this system. It uses two distinct logic sets:

1.  **Neumorphic (Structural):** Standard UI surfaces (cards, background containers) use a dual-shadow approach. A light shadow (#FFFFFF) at -5px, -5px and a dark shadow (#E0D1B8) at 5px, 5px with a 10-15px blur. This creates the "molded" look.
2.  **Glassmorphic (Overlay):** Top-level navigation, filters, and modal quick-views use a `backdrop-filter: blur(20px)` with a 60% white or primary-tinted opacity. This signals "ephemeral" or "temporary" states that sit above the physical base layer.

## Shapes
A consistent radius of 16px (0.5rem base) is used to soften the sporty aesthetic, making it feel more lifestyle-oriented and premium. 

Large product cards and glassmorphic modals should utilize `rounded-xl` (24px) to emphasize the "liquid-plastic" feel of the UI. Avoid sharp corners entirely to maintain the organic, tactile narrative.

## Components

### Buttons
- **Primary:** High-vibrancy gradients from #D76483 to #EF9CA4. These should have a "soft-glow" outer shadow of the primary color rather than a standard neumorphic shadow.
- **Secondary:** Neumorphic "raised" buttons that appear to be molded from the beige background, with #D76483 text.

### Cards & Containers
Product cards must be "raised" neumorphic surfaces. On "Tap," they should transition to an "inset" shadow state to provide haptic-visual feedback. Product images should have a slight `mix-blend-mode: multiply` to appear as if they are sitting inside the molded tray.

### Navigation & Overlays
The bottom navigation bar is a fixed glassmorphic slab. Use a thin 1px white border with 20% opacity to define the edge against the creamy background.

### Form Inputs
Input fields use the "inset" (sunken) neumorphic effect to indicate they are "empty space" ready for user data. Focused states should highlight the inner border with a soft #D76483 glow.

### Chips & Tags
Small, pill-shaped glassmorphic elements used for "New" or "Limited Edition" tags, featuring high blur and white semi-transparent backgrounds to pop against the beige base.