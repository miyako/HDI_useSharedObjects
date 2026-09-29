![version](https://img.shields.io/badge/version-16R6%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)

# HDI_useSharedObjects

Sharing state safely across 4D processes with the built-in `Storage` shared object -- atomic counters, fire-and-forget worker processes, and a read-only snapshot of a live shared object for display. Originally published by 4D as a **HDI** (*How Do I*) example for **4D v16 R6**; converted from the binary `.4DB` to the `.4DProject` architecture so it runs on current 4D releases.

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
  Forms/HDI/     Splash/startup form
  Forms/HDI2/     Main demo form: sequential ID buttons + concurrent inventory count
  Methods/        Storage/shared-object logic (GetNextID, Inventory, HowMany, DisplayResult) and startup (00_Start)
Resources/        Application resources (tips, images)
```

## References

- `Storage`: https://developer.4d.com/docs/commands/storage
- `New shared object`: https://developer.4d.com/docs/commands/new-shared-object
- `Use ... End use`: https://developer.4d.com/docs/commands/use
- `New process`: https://developer.4d.com/docs/commands/new-process
- `CALL FORM`: https://developer.4d.com/docs/commands/call-form
- `OB Copy`: https://developer.4d.com/docs/commands/ob-copy
- Index of v16/v17 HDIs: [miyako/4d-hdi](https://github.com/miyako/4d-hdi)
