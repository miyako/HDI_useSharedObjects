![version](https://img.shields.io/badge/version-16R6%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
![compatibility](https://img.shields.io/badge/compatibility-4D%2021.1%2B-1E90FF)

# HDI_useSharedObjects

Sharing state safely across 4D processes with the built-in `Storage` shared object -- atomic counters, fire-and-forget worker processes, and a read-only snapshot of a live shared object for display. Originally published by 4D as a **HDI** (*How Do I*) example for **4D v16 R6**; converted from the binary `.4DB` to the `.4DProject` architecture so it runs on current 4D releases, and further modernized (see [Modernization](#modernization) below) to current `4D 21.1` language and UI conventions.

## Origin

This project started as a binary `.4DB` example database originally distributed with 4D v16 R6. It was converted to the modern project architecture (`.4DProject`) using 4D 21's built-in binary-to-project conversion tool.

- **Blog post:** https://blog.4d.com/sharing-information-in-multi-threading-environment/
- **Original download:** https://download.4d.com/Demos/4D_v16_R6/HDI_useSharedObjects.zip

## Features

- **`Storage` as a cross-process key/value store** -- a single shared object, `Storage`, is visible to every process in the application; `GetNextID` lazily creates `Storage.counters` the first time it's needed rather than requiring it to be set up on startup.
- **Atomic read-modify-write with `Use ( ) ... End use`** -- every access to a shared object (`Storage`, `Storage.counters`, or the demo's own inventory object) is wrapped in `Use (...) ... End use` so concurrent processes can't race on the same value.
- **Fire-and-forget worker processes (`New process`)** -- `Inventory` creates one process per item via `New process`, each running `HowMany` independently and writing its own result into a single shared object passed to it by reference.
- **Cross-process callback (`CALL FORM`)** -- as each `HowMany` process finishes it decrements a shared item counter; the process that brings it to zero cleans up its bookkeeping keys and calls back into the originating window with `CALL FORM`, so the caller only has to handle the "all done" case once.
- **Read-only snapshot of a shared object (`OB Copy`)** -- `OB Copy(Storage)` takes a private copy of the live shared object so the demo form can display its contents without holding a lock on it.
- **`JSON Stringify` for at-a-glance inspection** -- `DisplayResult` serializes the finished inventory object to JSON text so the result of the concurrent counting can be shown in one field.

## How it works

`00_Start` opens the `HDI` splash window; its Demo button opens `HDI2`, which has two independent demos on separate tabs:

- **Sequential IDs** -- each button (`Alpha`, `Bravo`, `Charlie`, ...) calls `GetNextID` with its own key. All the counters live in one shared object (`Storage.counters`), so every button's counter persists and increments independently across calls, even though they all share the same underlying `Storage`.
- **Concurrent inventory count** -- the "How many?" button calls `Inventory`, which reads a keyword list of item names, creates one shared object to hold the running tally, and spawns one `New process` per item running `HowMany`. Each process sleeps for a random delay (simulating slow work), writes its count into the shared object, and decrements a shared "remaining" counter. The last process to finish calls `CALL FORM` back into the demo form, which hands the finished object to `DisplayResult` for `JSON Stringify`-based display.

## Points of interest

| File | Why it's worth reading |
|------|-------------------------|
| `Project/Sources/Methods/GetNextID.4dm` | The core pattern: lazily creating `Storage.counters` as a shared object, then `Use (objCounters) ... End use` to atomically increment a per-key counter without locking the rest of `Storage`. |
| `Project/Sources/Methods/Inventory.4dm` | Reads a keyword list, builds one shared object to hold the tally, and spawns one `New process` per item, passing the shared object by reference to each. |
| `Project/Sources/Methods/HowMany.4dm` | Simulates slow per-item work (`DELAY PROCESS`), writes its result into the shared inventory, and is the process that ends up calling back into the originating form once the last item finishes. |
| `Project/Sources/Methods/DisplayResult.4dm` | Receives the completed shared object back on the caller's process and serializes it with `JSON Stringify` for display. |
| `Project/Sources/Forms/HDI2/ObjectMethods/Button1.4dm` .. `Button6.4dm` | Each button calls `GetNextID` with a different key, showing several independent counters sharing one `Storage.counters` object. |

## Project structure

```
Project/Sources/
  Forms/HDI/                 Splash/startup form (+ BtnDemo.4dm object method for the HDI -> HDI2 transition)
  Forms/HDI2/                Main demo form: sequential ID buttons + concurrent inventory count
  Methods/                   Storage/shared-object logic (GetNextID, Inventory, HowMany, DisplayResult) and startup (00_Start)
  TableForms/                Input/Output list forms for the [SAMPLES] table
  styleSheets.css            Cross-platform dark mode (prefers-color-scheme) rules
  styleSheets_mac.css        macOS Liquid Glass / mac-classic button sizing
  styleSheets_windows.css    Windows-specific rules
Resources/
  en.lproj/, ja.lproj/       XLIFF localisation (menu, HDI, HDI2, messages, TableForms)
```

## Modernization

This project has been modernized from its original 4D v16 R6 patterns to current 4D language and UI conventions:

- **Localisation** -- every hardcoded menu title, form label, and alert/message string has been replaced with `:xliff:` references or `Localized string(...)` calls. Translations are grouped by purpose (`menuEN/JA.xlf`, `HDIEN/JA.xlf`, `HDI2EN/JA.xlf`, `messagesEN/JA.xlf`, `TableFormsEN/JA.xlf`) under `Resources/en.lproj/` and `Resources/ja.lproj/`.
- **Modern variable syntax** -- all deprecated `C_LONGINT`/`C_TEXT`/`C_OBJECT`/etc. directives have been converted to `var` declarations and `#DECLARE` parameter/return syntax, including `Compiler_Variables.4dm` and `Compiler_Methods.4dm`.
- **Standard menu actions** -- menu items that only wrapped a single built-in command use the `"action"` property in `menus.json` instead of a project method.
- **Method visibility** -- subroutines, form-dependent methods, and callback/object methods are marked `"invisible":true` so they no longer clutter the Run > Method... dialog; `00_Start` (the menu entry point) remains visible.
- **Startup dialog pattern** -- `00_Start.4dm` uses `#DECLARE`, `CALL WORKER` (instead of `New process`) to reach the application process, non-blocking `DIALOG(...;*)`, and window-reuse detection so re-running it brings the existing splash window to front instead of opening a duplicate.
- **Dark mode & Liquid Glass** -- `styleSheets.css` uses `"automatic"`/`"automaticAlternate"` colors and `prefers-color-scheme` media queries throughout both forms; `styleSheets_mac.css` sizes every button for both the Liquid Glass (27px) and classic (23px) macOS themes.
- **Listboxes** -- the project contains no listbox objects, so the `truncateMode`/`resizingMode` listbox-default conventions do not apply here.

## References

- `Storage`: https://developer.4d.com/docs/commands/storage
- `New shared object`: https://developer.4d.com/docs/commands/new-shared-object
- `Use ... End use`: https://developer.4d.com/docs/commands/use
- `New process`: https://developer.4d.com/docs/commands/new-process
- `CALL FORM`: https://developer.4d.com/docs/commands/call-form
- `OB Copy`: https://developer.4d.com/docs/commands/ob-copy
- `Localized string`: https://developer.4d.com/docs/commands/localized-string
- `#DECLARE`: https://developer.4d.com/docs/Concepts/parameters#declaring-parameters
- `CALL WORKER`: https://developer.4d.com/docs/commands/call-worker
- CSS in 4D (dark mode, Liquid Glass): https://developer.4d.com/docs/FormEditor/stylesheets
- Index of v16/v17 HDIs: [miyako/4d-hdi](https://github.com/miyako/4d-hdi)
