# frozen_string_literal: true

namespace :task do
  namespace :report do
    task generate: [:environment] do
      user = ARGV[1]
      puts 'Generating report...'
      TaskReportService.new.user(user: user).generate
      puts 'Report generated!'
    end
  end
end
