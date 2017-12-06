COMMANDS_MATCHER_SEP = ', '

RSpec::Matchers.define :match_commands do |expected_str|

  match do |actuals|
    return false unless expected_str.is_a?(String)
    return false unless actuals.is_a?(Array)

    strs = expected_str.split(COMMANDS_MATCHER_SEP)
    return false unless strs.length == actuals.length

    result = true
    strs.each_with_index do |str, i|
      actual = actuals[i]
      expected = Svgcode::GCode::Command.new(str)

      unless actual.roughly_equal?(expected)
        result = false
        break
      end
    end

    result
  end

  failure_message do |actuals|
    "Expected commands:\n"\
    "  #{pretty_commands(actuals)}\n"\
    "to match:\n"\
    "  #{expected_str}"
  end

  failure_message_when_negated do |actuals|
    "Expected commands:\n"\
    "  #{pretty_commands(actuals)}\n"\
    "not to match:\n"\
    "  #{expected_str}"
  end

  def pretty_commands(commands)
    if commands.is_a?(Array)
      commands.collect { |c| c.to_s }.join(COMMANDS_MATCHER_SEP)
    else
      commands.inspect
    end
  end
end
