# Breeze UI

Breeze is a modular Roblox Luau interface library with an airy glass design, responsive motion, and a small composition-based API.

> Preview media is planned for the first tagged release. Run `examples/showcase.luau` in Studio to see the complete interface.

## Features

- Multiple draggable, animated windows with tabs and collapsible sections
- Buttons, toggles, checkboxes, sliders, inputs, multiline textboxes, searchable dropdowns, multi-dropdowns, keybinds, labels, paragraphs, dividers, images, and progress bars
- Runtime Breeze, Dark, Light, Midnight, and custom themes without rebuilding controls
- Synchronized flags, optional persistence adapters, notifications, modal dialogs, and centralized overlays
- Mouse, touch, keyboard, basic gamepad selection/cancel behavior, protected callbacks, and deterministic cleanup

## Installation

With [Rojo](https://rojo.space/), sync `default.project.json`; the package appears at `ReplicatedStorage.Breeze`. The source only uses standard Roblox services. Do not place secret or server-only logic in client callbacks.

```lua
local Breeze = require(game.ReplicatedStorage.Breeze)
local window = Breeze:CreateWindow({ Title = "Breeze UI", Subtitle = "Quick start" })
local tab = window:AddTab({ Title = "Home", Icon = "home" })
local section = tab:AddSection({ Title = "General" })
section:AddButton({ Title = "Execute", Callback = function() print("Executed") end })
section:AddToggle({ Title = "Enabled", Flag = "Enabled", Default = false })
```

## Architecture

`src/init.luau` owns the library lifetime and composes managers. `core` implements state, windows, tabs, and sections; `components` contains control factories; `managers` coordinate themes, global input, overlays, notifications, and dialogs; `utilities` contains low-level creation, styling, validation, icons, animation, cleanup, and callback isolation. Handles are closure-backed tables rather than class/metatable hierarchies.

## API

### Windows, tabs, and sections

`CreateWindow` accepts `Title`, `Subtitle`, `Logo`, `Theme`, `Size`, `Position`, `MinSize`, `MaxSize`, and `Draggable`. Window handles expose `AddTab`, `Minimize`, `Restore`, `Hide`, `Show`, `SetTitle`, `SetSubtitle`, `SetLogo`, and `Destroy`. Tabs expose `AddSection`, `SetActive`, `SetDisabled`, `SetTitle`, and `Destroy`. Sections expose the `Add…` methods below, `SetCollapsed`, `Toggle`, `SetVisible`, and `Destroy`.

### Components

Common options are `Title`, `Description`, `Default`, `Disabled`, `Visible`, `Flag`, and `Callback`. Value controls consistently provide `Set` and `Get`; common handles provide `SetTitle`, `SetDescription`, `SetVisible`, `SetDisabled`, and `Destroy` where meaningful.

| Section method | Additional options / methods |
| --- | --- |
| `AddButton` | `Callback` |
| `AddToggle`, `AddCheckbox` | boolean value |
| `AddSlider` | `Min`, `Max`, `Increment` |
| `AddInput`, `AddTextbox` | `Placeholder`, `CharacterLimit`, `Numeric`, `Changed`; `Focus`, `Clear` |
| `AddDropdown`, `AddMultiDropdown` | `Values`; `SetValues`, `Clear`, `Open`, `Close` |
| `AddKeybind` | `Enum.KeyCode`; `Changed`, `Cancel` |
| `AddLabel`, `AddParagraph`, `AddDivider` | display content |
| `AddImage` | `Image`, `Height` |
| `AddProgressBar` | normalized value from 0 to 1 |

Dropdowns search and scroll, normalize malformed values, dismiss on outside input, and share one overlay layer. Sliders use input events rather than frame polling and accept mouse or touch drags.

### Notifications and dialogs

`Breeze:Notify({ Title, Content, Type, Duration })` returns a handle with `Dismiss`. Five notifications are retained at once. Types may be `Default`, `Info`, `Success`, `Warning`, or `Error`.

`Breeze:Dialog({ Title, Content, DismissOnOutside, Buttons })` creates a layered modal. Button entries accept `Title`, `Primary`, `Callback`, and `Close`; the returned handle exposes `Close`. Escape and gamepad B dismiss it.

### Themes, flags, persistence, and cleanup

Call `SetTheme("Midnight")` or pass a custom table using the Breeze tokens (`Accent`, `Background`, `Surface`, `SurfaceSecondary`, `Text`, `MutedText`, `Stroke`, status colors, `CornerRadius`, and `Transparency`). Existing bindings update in place.

Read `Breeze.Flags.Name` or call `GetFlag`, `SetFlag`, and `ResetFlags`. Persistence is optional: `SetPersistenceAdapter` accepts a table implementing `Save(self, name, flags)` and `Load(self, name)`. Call `Breeze:Destroy()` to remove windows, overlays, modals, notifications, connections, state, and the `ScreenGui`.

## Mobile and gamepad

Touch uses Roblox `Activated` and input events, sliders and window headers track touch drags, navigation scrolls, and dialogs clamp to narrow viewports. Keyboard-only keybind capture remains visible but optional on touch-only devices. Roblox selection handles buttons and tabs; gamepad B closes dialogs.

## Examples

See `examples/basic.luau`, `components.luau`, `notifications.luau`, `themes.luau`, and `showcase.luau`.

## Troubleshooting

- **No UI appears:** require the module from a LocalScript after `PlayerGui` exists. Breeze falls back from `CoreGui` to `PlayerGui`.
- **An icon is wrong:** named icons use a central fallback; pass a valid `rbxassetid://` URI for custom art.
- **A callback errors:** Breeze warns with the control context and keeps interaction alive.
- **Runtime visual verification:** Studio/device testing is still required because CI cannot render Roblox UI.

## Contributing and license

Keep dependencies directed from core/components toward utilities, add examples for public API changes, and run `python tests/static_check.py`. Breeze is available under the [MIT License](LICENSE).
