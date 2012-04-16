if Rake::Task.task_defined? 'spec:statsetup'
  Rake::Task['spec:statsetup'].enhance do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << ['Mailers', 'app/mailers']
    if File.exist?('spec/acceptance')
      ::STATS_DIRECTORIES << ['Acceptance specs', 'spec/acceptance']
      ::CodeStatistics::TEST_TYPES << 'Acceptance specs'
    end
    if File.exist?('spec/support')
      ::STATS_DIRECTORIES << ['Spec support', 'spec/support']
      ::CodeStatistics::TEST_TYPES << 'Spec support'
    end

  end
end
