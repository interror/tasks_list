class TaskListController < ApplicationController

  before_filter :authorize

  def index
    @select_users = User.all.map{|elm| elm = [elm.name, elm.id] }
    @tasks = @current_user.tasks
    @tasks << Task.where(performer: @current_user.id)
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
    @tasks = @current_user.tasks
    p @tasks
    @tasks << Task.where(performer: @current_user.id)
    @tasks = @tasks.order("#{params[:sort_data].first} #{params[:sort_data].last}")

    p @tasks
    #render nothing: true
    respond_to do |format|
     format.js
    end
  end


end
