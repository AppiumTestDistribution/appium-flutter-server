# Testsigma Flutter Recorder

This package adds two routes to the Appium Flutter server. Arcus uses them to record steps on a Flutter app that exposes **no semantics**.

Design: see `docs/recorder_rfc.md`.

---

## 1. Install

Customer adds our package in place of the stock `appium_flutter_server`. The package name does not change, so `integration_test/appium_test.dart` does not change.

```yaml
# customer pubspec.yaml
dev_dependencies:
  appium_flutter_server:
    git:
      url: https://github.com/TestsigmaInc/appium-flutter-server
      path: server
      ref: v0.0.34-ts.1        # always a tag, never a branch
```

---

## 2. Endpoints

| Endpoint | Session | Answers the question |
|---|---|---|
| `GET /ts/recorder/about` | Not needed | "Does this app have the recorder, and which version?" |
| `GET /session/:sessionId/ts/recorder/page_source?maxNodes=600` | Needed | "What is on the screen, and where?" |

Both routes use the normal server response: `{ "sessionId": ..., "value": ... }`. `page_source` checks the session id in the path, the same as the other `/session/:sessionId/...` routes.

### 2.1 `GET /ts/recorder/about`

```json
{ "recorderApi": 1, "serverVersion": "0.0.34-ts.1", "sessionId": "e1c2…", "platform": "android" }
```

- `sessionId` is `null` when there is no active session.
- A stock server returns 404 for this route. Arcus then asks the customer to switch the dependency.

### 2.2 `GET /session/:sessionId/ts/recorder/page_source`

Needs an active session. In Arcus the Appium Flutter driver opens it. Get the id from `GET /ts/recorder/about`.

To try it by hand:

```bash
curl -s -X POST http://localhost:9000/session -H 'Content-Type: application/json' -d '{"capabilities":{}}'
curl -s http://localhost:9000/session/<sessionId>/ts/recorder/page_source
```

| Query | Default | Meaning |
|---|---|---|
| `maxNodes` | `600` | Stop after this many nodes, and set `truncated: true` |

```json
{
  "hash": "9f3a61c2",
  "settled": true,
  "truncated": false,
  "hasPlatformViews": false,
  "screen": {
    "width": 411.4, "height": 914.3, "devicePixelRatio": 2.625,
    "padding": { "top": 24.0, "bottom": 0.0, "left": 0.0, "right": 0.0 },
    "viewInsets": { "bottom": 0.0 },
    "orientation": "portrait"
  },
  "nodes": [
    { "id": "n0", "parent": null, "type": "MaterialApp", "rect": [0, 0, 411.4, 914.3], "visibleRect": [0, 0, 411.4, 914.3] },
    { "id": "n4", "parent": "n0", "type": "ElevatedButton", "rect": [16, 316, 379.4, 48], "visibleRect": [16, 316, 379.4, 48],
      "key": "login_button" },
    { "id": "n5", "parent": "n4", "type": "InkWell", "types": ["InkWell", "GestureDetector", "RawGestureDetector"],
      "rect": [16, 320, 379.4, 40], "visibleRect": [16, 320, 379.4, 40], "clickable": true, "enabled": true, "focusable": true },
    { "id": "n6", "parent": "n5", "type": "Text", "types": ["Text", "RichText"], "rect": [170, 330, 70, 20], "visibleRect": [170, 330, 70, 20], "text": "Log in" }
  ]
}
```

| Field | Meaning |
|---|---|
| `hash` | FNV-1a hash of `nodes`. Same screen gives same hash. bt-runner sends it as `x-page-source-hash`. |
| `settled` | `false` when an animation did not stop. bt-runner can ask again. |
| `truncated` | `true` when the walk stopped at `maxNodes`. The list is not complete. |
| `hasPlatformViews` | `true` when the screen has a native view (map, web view). The walk cannot see inside it. |
| `screen` | Screen size, safe area and keyboard height, in logical pixels |

---

## 3. Node fields

All rects are `[x, y, width, height]` in **logical pixels**, rounded to one decimal place. On iOS this is the same as iOS points.

| Field | Meaning |
|---|---|
| `id`, `parent` | Node id, and the id of the nearest reported ancestor. The root is `n0`. |
| `type` | First public widget type that is not a framework wrapper (`Padding`, `Semantics`, `Builder` …) |
| `types` | All public, non-wrapper widget types that form this box, outermost first. Only sent when there are 2 or more. |
| `rect` | Full rect of the box |
| `visibleRect` | `rect` clipped by the screen and by the nearest scroll viewport. Draw this one. |
| `key` | `ValueKey<String>` value. Other key types are not sent, because `find.byKey` cannot match them. |
| `text` | `Text.data`, or the plain text of `Text.rich` |
| `inputValue` | Typed value of `EditableText`. Show only. Do not use it for a locator. |
| `tooltip` | `Tooltip.message` |
| `icon` | `Icon` code point |
| `semanticsLabel` | Semantics label. **Debug builds only.** |
| `hint`, `label` | `TextField` hint text and label text. Show only. |
| `clickable` | The box has a gesture, or it is a text input, and it is not `blocked` |
| `editable` | The box contains `EditableText` |
| `enabled` | `false` for a disabled button, text field or toggle, or a box under `IgnorePointer` / `AbsorbPointer` |
| `focusable`, `focused` | Focus state of a tap target or text input |
| `checked` | Checkbox, Switch or Radio value |
| `scrollable` | The box is a scroll view (`ListView`, `GridView`, `SingleChildScrollView` …) |
| `blocked` | The box is under a dialog. bt-runner maps it to `enabled=false`, `clickable=false`. |

Fields with no value, and `false` flags, are not sent.

---

## 4. How the walk works

The walk visits each widget once, from the root.

1. **Group widgets into boxes.** Widgets with the same on-screen rect form one box.
2. **Keep useful boxes only.** A box becomes a node when it has a finder value (key, text, tooltip, icon, semantics label), or it is interactive (`RawGestureDetector`, `Listener`, `EditableText`, `Scrollable`). Children of a dropped box go to the nearest kept box.
3. **Skip what the user cannot see.**
   - The parent does not paint it: `Offstage`, `Opacity(0)`, `Visibility(visible: false)`.
   - The route is under an opaque route: `TickerMode(enabled: false)`.
   - The tab is not selected: only the `IndexedStack` child at `index`.
   - The box is off screen or scrolled out.
4. **Mark the page under a dialog.** Boxes that come before the topmost `ModalBarrier` in the same `Overlay` get `blocked: true`.

---

## 5. Known limits

| Limit | Why |
|---|---|
| A Material button gives two nodes: the outer tap-target box (key, `ElevatedButton`) and the inner box (`InkWell`, clickable) | The tap target is 48 px high. The visible button is 40 px high. The rects are different, so they are different boxes. |
| `semanticsLabel` is not sent in profile builds | Flutter keeps this value in debug builds only. The `-flutter semantics label` finder has the same limit. |
| Items that are scrolled out are not sent | The user scrolls first, then Arcus reads the page source again |
| The walk cannot see inside platform views | Check `hasPlatformViews` |
| The server log prints the full response | The existing `RequestHandler` logs every response. We do not change existing code. |

---

## 6. Files

```
server/lib/src/ts_recorder/
  about/
    about_handler.dart           GET /ts/recorder/about
  page_source/
    page_source_handler.dart     GET /session/:sessionId/ts/recorder/page_source
    tree_walker.dart             Walks the tree once and builds the node list
    node.dart                    One node, and its JSON
    node_reader.dart             Reads key, text, icon, state from a widget
    visibility.dart              Rules for what the user cannot see
    screen.dart                  Screen size, pixel ratio, safe area

server/test/ts_recorder/         Widget tests. Run: cd server && flutter test test/ts_recorder
```

The only change to existing server code is in `server.dart`: two imports, and two `_registerGet(...)` lines at the end of `_registerRoutes()`.
