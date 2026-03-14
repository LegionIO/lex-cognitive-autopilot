# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveAutopilot
      class Client
        include Runners::CognitiveAutopilot

        def initialize(engine: nil)
          @default_engine = engine || Helpers::AutopilotEngine.new
        end
      end
    end
  end
end
