# frozen_string_literal: true

class Task::TaskController < ApplicationController
  layout 'application'
  before_action :authenticate_user

  def index
    params.merge!(user_id: session[:user_id])
    items = TaskService.filtered(params:)

    render 'task/index', locals: { result: items }
  end

  def show
    begin
      task = TaskService.find(params[:id], session[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      return render json: { error: true, message: e.message }, status: :not_found
    end

    render json: task, status: :ok
  end

  def create
    task = TaskService.create(
      title: task_params[:title],
      description: task_params[:description],
      is_completed: task_params[:isCompleted],
      user_id: task_params[:user_id]
    )

    if task.is_a?(ActiveRecord::RecordInvalid)
      render json: { error: true, message: task.message }, status: :unprocessable_entity
    else
      render json: task, status: :created
    end
  end

  def update
    task = TaskService.update(
      task_id: params[:id],
      user_id: session[:user_id],
      title: task_params[:title],
      description: task_params[:description],
      is_completed: task_params[:isCompleted]
    )

    if task.is_a?(ActiveRecord::RecordNotFound)
      render json: { error: true, message: task.message }, status: :not_found
    elsif task.is_a?(ActiveRecord::RecordInvalid)
      render json: { error: true, message: task.message }, status: :unprocessable_entity
    else
      render json: task, status: :ok
    end
  end

  def destroy
    TaskService.destroy(params[:id], session[:user_id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :isCompleted, :user_id)
  end
end
