# oUF_Kinmeic
An unit frame plugin for world of warcraft

Includes oUF 14.2.1 with local Forever compatibility adjustments. Upstream: https://github.com/oUF-wow/oUF

## Installation

Copy both `oUF/` and `oUF_Kinmeic/` into `World of Warcraft/_forever_/Interface/AddOns/`, then reload the UI. Keep the two folders alongside each other.

The framework retains its upstream license in `oUF/LICENSE.txt`. Local compatibility changes are documented in `oUF/FOREVER_COMPATIBILITY.md`.

## Compatibility

Supports World of Warcraft Forever 1.60.1 (`camelot`) and requires an oUF build that supports interface 16001. Health and power tags use the native percent and number-formatting APIs so Lua does not calculate with secret values. Aura icons use oUF's AuraContainer and native cooldown duration handling. Health and power bars use native StatusBar interpolation, and the castbar uses oUF's native duration text binding.
