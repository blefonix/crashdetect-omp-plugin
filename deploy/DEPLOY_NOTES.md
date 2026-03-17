# CrashDetect deploy notes

## Build

```bash
./scripts/build-local.sh dev
./scripts/build-local.sh stage
./scripts/build-local.sh prod
```

Artifacts are written to:
- `out/dev/crashdetect.so`
- `out/stage/crashdetect.so`
- `out/prod/crashdetect.so`

## Install to a server plugins directory

```bash
./scripts/install-plugin.sh stage /path/to/server/plugins
```

## Runtime profile guidance

- **dev/stage**:
  - plugin enabled
  - optional tracing while debugging
- **prod**:
  - default: disabled unless actively investigating a crash
  - if enabled, use low-noise settings (avoid broad tracing)

## Suggested server.cfg options (debug session)

```cfg
crashdetect_log crashdetect.log
long_call_time 5000
; trace p
; trace_filter Player
```

## Safety checks before restart

1. Confirm plugin architecture matches server architecture.
2. Keep previous plugin copy for instant rollback.
3. Restart and confirm startup log includes crashdetect load.
