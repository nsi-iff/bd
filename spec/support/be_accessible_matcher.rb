RSpec::Matchers.define :be_accessible do
  def attribute
    proc { example.metadata[:example_group][:description_args].first }.call
  end

  match do
    described_class.accessible_attributes.include?(attribute)
  end

  failure_message_for_should { "#{attribute} should be accessible" }
  failure_message_for_should_not { "#{attribute} should not be accessible" }
end
