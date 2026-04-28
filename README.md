# Jsonique

Jsonique is a small macOS app for opening, browsing, and editing JSONL dataset files. It is built with SwiftUI and is aimed at making machine-learning fine-tuning datasets easier to inspect than they are in a plain text editor.

The project was built quickly and is still early, but it already has the core shape of a lightweight JSONL workspace: import files, select rows, add new rows, and edit supported dataset types.

## Features

- Import one or more JSONL files into a temporary working copy.
- Create a new blank JSONL file from inside the app.
- Browse imported dataset files from a sidebar.
- Parse JSONL rows into typed dataset formats used by MLX-LM LoRA fine-tuning:
  - `text`
  - `prompt` / `completion`
  - chat messages
  - tool-calling rows
- Add new rows from the supported dataset formats.
- Edit text rows with a dedicated editor, including wrapping and font size controls.

## Current Status

Jsonique is a work in progress. Text rows currently have the most complete editing experience. Completion, chat, and tool-calling rows are parsed and represented in the app, but their dedicated editors are still placeholders.

Imported files are copied into the system temporary directory before editing, so the original selected files are not modified directly.

## Requirements

- macOS
- Xcode
- SwiftUI

The Xcode project is currently configured with a macOS deployment target of `26.2`.

## Dependencies

Jsonique uses Swift Package Manager dependencies resolved by Xcode:

- [`TextEditor`](https://github.com/AryanRogye/TextEditor)
- [`LocalShortcuts`](https://github.com/AryanRogye/LocalShortcuts.git), pulled in through the package resolution graph

## Getting Started

1. Clone the repository.
2. Open `Jsonique.xcodeproj` in Xcode.
3. Let Xcode resolve Swift Package Manager dependencies.
4. Select the `Jsonique` scheme.
5. Build and run.

## JSONL Formats

Jsonique is modeled around the local JSONL dataset formats documented by [`mlx-lm` LoRA fine-tuning](https://github.com/ml-explore/mlx-lm/blob/main/mlx_lm/LORA.md#data).

For local MLX-LM training, datasets are typically arranged as:

- `train.jsonl` for training.
- `valid.jsonl` for optional validation.
- `test.jsonl` for evaluation.

Jsonique expects one JSON object per line. Empty lines are ignored. MLX-LM supports `chat`, `tools`, `completions`, and `text` rows, and each example should stay on a single line.

Example text row:

```json
{"text":"Write your dataset text here."}
```

Example completion row:

```json
{"prompt":"Question: What is JSONL?","completion":"Answer: JSONL is newline-delimited JSON."}
```

Example chat row:

```json
{"messages":[{"role":"user","content":"Hello"},{"role":"assistant","content":"Hi."}]}
```

Example tool-calling row:

```json
{"messages":[{"role":"user","content":"What is the weather in San Francisco?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\":\"San Francisco, USA\",\"format\":\"celsius\"}"}}]}],"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country."},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
```

MLX-LM can also map custom key names for completion and text datasets through YAML config, but Jsonique currently expects the default keys shown above.

## Roadmap

- Save edited working files back to disk.
- Add full editors for completion, chat, and tool-calling rows.
- Improve validation and error reporting for malformed JSONL.
- Add export options.
- Add tests for parsing and row editing behavior.

## License

Jsonique is available under the MIT License. See [LICENSE](LICENSE) for details.
