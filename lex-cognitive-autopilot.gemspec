# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_autopilot/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-autopilot'
  spec.version       = Legion::Extensions::CognitiveAutopilot::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'System 1/System 2 dual-process autopilot for LegionIO'
  spec.description   = 'Models automatic vs deliberate processing modes based on Kahneman dual-process ' \
                       'theory. Routine tasks run on autopilot (fast, low-cost), novel tasks trigger ' \
                       'deliberate mode (slow, accurate). Tracks mode switching and override events.'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-autopilot'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = 'https://github.com/LegionIO/lex-cognitive-autopilot'
  spec.metadata['documentation_uri']     = 'https://github.com/LegionIO/lex-cognitive-autopilot/blob/master/README.md'
  spec.metadata['changelog_uri']         = 'https://github.com/LegionIO/lex-cognitive-autopilot/blob/master/CHANGELOG.md'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/LegionIO/lex-cognitive-autopilot/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ['lib']
end
