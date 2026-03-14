# lex-cognitive-autopilot

**Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Models automatic vs deliberate processing modes based on Kahneman's dual-process theory (System 1 / System 2). Routine tasks run on autopilot (fast, low cognitive cost); novel tasks trigger deliberate mode (slow, careful, higher cost). Tracks mode switching events, familiarity accumulation, and energy drain from deliberate processing.

## Gem Info

- **Gem name**: `lex-cognitive-autopilot`
- **Version**: `0.1.0`
- **Module**: `Legion::Extensions::CognitiveAutopilot`
- **Ruby**: `>= 3.4`
- **License**: MIT

## File Structure

```
lib/legion/extensions/cognitive_autopilot/
  cognitive_autopilot.rb
  version.rb
  client.rb
  helpers/
    constants.rb
    autopilot_engine.rb
    routine.rb
    mode_event.rb
  runners/
    cognitive_autopilot.rb
```

## Key Constants

From `helpers/constants.rb`:

- `PROCESSING_MODES` — `%i[autopilot deliberate transitioning]`
- `TASK_DOMAINS` — `%i[routine analysis creative social emergency administrative technical unknown]`
- `MAX_ROUTINES` = `200`, `MAX_EVENTS` = `500`
- `FAMILIARITY_BOOST` = `0.08`, `FAMILIARITY_DECAY` = `0.02`
- `AUTOPILOT_THRESHOLD` = `0.7` (familiarity >= this = autopilot-ready)
- `DELIBERATE_THRESHOLD` = `0.3` (familiarity <= this = novel)
- `OVERRIDE_COST` = `0.15` (energy drain when manually switching or novel routine triggers override)
- `AUTOPILOT_COST` = `0.02`, `DELIBERATE_COST` = `0.10`
- `DEFAULT_ENERGY` = `1.0`
- `FAMILIARITY_LABELS` — `0.8+` = `:expert`, `0.6` = `:proficient`, `0.4` = `:familiar`, `0.2` = `:learning`, below = `:novel`
- `ENERGY_LABELS` — `0.8+` = `:energized` through `0.2` = `:exhausted`

## Runners

All methods in `Runners::CognitiveAutopilot`:

- `register_routine(pattern:, domain: :routine, familiarity: 0.0)` — registers a new task pattern for familiarity tracking
- `execute_routine(routine_id:, success: true)` — executes a routine, boosting/decaying familiarity, draining energy, auto-switching mode
- `switch_to_deliberate(trigger: 'manual')` — forces deliberate mode; drains `OVERRIDE_COST` energy
- `switch_to_autopilot(trigger: 'manual')` — forces autopilot mode; no energy cost
- `rest(amount: 0.1)` — recovers energy
- `decay_all` — applies familiarity decay to all routines
- `autopilot_routines` — lists routines with familiarity >= `AUTOPILOT_THRESHOLD`
- `novel_routines` — lists routines with familiarity <= `DELIBERATE_THRESHOLD`
- `most_familiar(limit: 5)` — top routines by familiarity
- `get_routine(routine_id:)` — single routine lookup
- `autopilot_status` — full report: mode, energy, ratios, override count, most familiar

## Helpers

- `AutopilotEngine` — manages `@routines` hash and `@events` hash; tracks `@current_mode` and `@energy`. Auto-switches mode: routine becomes familiar -> autopilot; novel routine encountered during autopilot -> deliberate override with energy cost.
- `Routine` — pattern-based task with `familiarity`, `domain`, execution history. Methods: `execute!(success:)`, `autopilot_ready?`, `novel?`, `decay!`.
- `ModeEvent` — records each mode transition with `from_mode`, `to_mode`, `trigger`, `energy_cost`. `override?` returns true when the transition was non-routine.

## Integration Points

- Complements `lex-cognitive-control` (which manages goal state and effort allocation) — autopilot focuses on task familiarity while control manages goal priority.
- `lex-tick` can use autopilot mode to determine whether to run a lightweight processing cycle (autopilot) or full 11-phase cycle (deliberate).
- `update_cognitive_autopilot` (decay cycle) is the natural periodic runner to call for familiarity decay.

## Development Notes

- Mode auto-switching occurs inside `execute_routine`: familiar routine in deliberate -> switches to autopilot; novel routine in autopilot -> switches to deliberate with `OVERRIDE_COST`.
- `AutopilotEngine` starts in `:deliberate` mode with full energy. Autopilot mode is earned, not default.
- Pruning on `register_routine`: when capacity reached, removes the least-familiar routine (lowest investment discarded first).
- Energy floor is 0.0; `rest!` caps at 1.0. Exhausted state (`energy <= 0.2`) is reported but not automatically enforced — callers must respond.
