# frozen_string_literal: true

require 'csv'
require 'time'
class TaskReportService < TaskService
  def user(user: nil?)
    @user = user
    self
  end

  def generate
    records = @user ? Task.where(user_id: @user) : Task.all
    headers = %w[UserId Title Description isCompleted CreatedAt]
    date = Time.now.strftime('%FT%T')
    filename = @user ? "report_#{@user}_#{date}.csv" : "report_#{date}.csv"
    report_path = Rails.root.join('tmp', filename)

    create_file(records, headers, report_path) do |record|
      [record.user_id, record.title, record.description, record.isCompleted, record.created_at]
    end
  end

  def create_file(records, headers, report_path)
    CSV.open(report_path, 'wb') do |csv|
      csv << headers
      records.each do |record|
        csv << yield(record)
      end
    end
  end
end
