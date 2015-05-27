class TaskListController < ApplicationController

  before_filter :authorize
  before_action :find_task, only: [:show, :edit]

  def index
    @select_users = User.all.map{|elm| elm = [elm.name, elm.id] }
    @tasks = Task.where("tasks.user_id = ? OR tasks.performer = ? ", @current_user.id, @current_user.id)

  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    data = params.require(:task).permit(:description, :performer_id)

    @task = Task.create(description: data["description"], owner: @current_user.name, state: "open", performer: data['performer_id'].to_i, user_id: @current_user.id)

    respond_to do |format|
     format.html
     format.js
    end
  end

  def sort
    @tasks = Task.where("tasks.user_id = ? OR tasks.performer = ? ", @current_user.id, @current_user.id)
    @tasks = @tasks.order("#{params[:sort_data].first} #{params[:sort_data].last}")

    respond_to do |format|
     format.js
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    render nothing: true
  end

  def edit
    @task = Task.find(params[:id])
    respond_to do |format|
     format.js
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update_attributes(params.require(:task).permit(:description, :performer, :state))
    respond_to do |format|
     format.js
    end
  end

private

  def find_task
    @select_users = User.all.map{|elm| elm = [elm.name, elm.id] }
    @task = Task.find(params[:id])
  end
end
#SELECT *FROM USERS WHERE email = :email
