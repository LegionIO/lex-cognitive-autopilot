# lex-cognitive-autopilot

System 1/System 2 dual-process autopilot for LegionIO. Models automatic vs deliberate processing modes based on Kahneman's dual-process theory.

## What It Does

Routine tasks run on autopilot — fast, low cognitive energy cost — while novel or surprising tasks trigger deliberate mode: slower, more careful, and significantly more expensive. The extension tracks task patterns, accumulates familiarity through repetition, and automatically switches between modes as familiarity changes. It also models cognitive energy: deliberate processing drains reserves, and forced overrides (switching from autopilot to deliberate mid-stream) have the highest energy cost.

## Usage

```ruby
client = Legion::Extensions::CognitiveAutopilot::Client.new

routine = client.register_routine(pattern: 'daily_standup', domain: :routine)
client.execute_routine(routine_id: routine[:routine][:id], success: true)

# After enough successful executions, familiarity reaches autopilot threshold
# and the engine auto-switches to autopilot mode

client.autopilot_status
# => { current_mode: :autopilot, energy: 0.88, autopilot_ratio: 0.7, ... }

client.rest(amount: 0.2)    # recover energy
client.decay_all             # apply familiarity decay (call periodically)
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
