class TaskListController < ApplicationController

  before_filter :authorize
  before_action :find_task_and_users, only: [:show, :edit]

  def index
    @users = User.all
    @tasks = Task.where("tasks.user_id = ? OR tasks.performer = ? ", @current_user.id, @current_user.id)

  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    data = params.require(:task).permit(:description, :performer)
    p @current_user.id.class
    @task = Task.create description: data["description"],
                        owner: @current_user.name,
                        state: "open",
                        performer: User.find(data['performer'].to_i),
                        user_id: @current_user.id

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
    update_value = params.require(:task).permit(:description, :performer, :state)
    update_value[:performer] = User.find(update_value[:performer].to_i)
    @task.update_attributes(update_value)
    respond_to do |format|
     format.js
    end
  end

private

  def find_task_and_users
    @users = User.all
    @task = Task.find(params[:id])
  end
end
#SELECT *FROM USERS WHERE email = :email
