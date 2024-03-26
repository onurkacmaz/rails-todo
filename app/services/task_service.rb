# frozen_string_literal: true

class TaskService
  include PaginationHelper

  def self.create(title:, description:, is_completed:, user_id:)
    Task.create!(title:, description:, isCompleted: is_completed, user_id:)
  rescue ActiveRecord::RecordInvalid => e
    e
  end

  def self.update(task_id:, user_id:, title: nil, description: nil, is_completed: false)
    task = Task.where(id: task_id).where(user_id:).first

    return ActiveRecord::RecordNotFound.new('Task not found') if task.nil?

    task.title = title unless title.nil?

    task.description = description unless description.nil?

    task.isCompleted = is_completed unless is_completed.nil?

    task.save!
  rescue ActiveRecord::RecordInvalid => e
    e
  end

  def self.all
    Task.all
  end

  def self.find(task_id, user_id)
    Task.where(id: task_id).where(user_id:).first
  end

  def self.destroy(task_id, user_id)
    Task.where(id: task_id).where(user_id:).destroy_all
  end

  def self.filtered(params:)
    page = params[:page].to_i
    limit = params[:limit].to_i

    tasks = Task
            .where(isCompleted: params[:status] ? params[:status] == 'completed' : false)
            .where(user_id: params[:user_id])
            .order(created_at: :desc)

    PaginationHelper.paginate(scope: tasks, page:, limit:)
  end
end
