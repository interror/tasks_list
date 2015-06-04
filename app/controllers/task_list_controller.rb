class TaskListController < ApplicationController
  include ActionController::Live


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
    @task = Task.create description: data["description"],
                        owner: @current_user.name,
                        state: "open",
                        performer: User.find(data['performer'].to_i),
                        user_id: @current_user.id
    $redis.publish('task.create', @task.to_json)
    respond_to do |format|
     format.html
     format.js
    end
  end

  def create_live
    data = params["add_data"]
    @task = Task.find(data)
    respond_to do |format|
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
    $redis.publish('task.delete', @task.to_json)
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
    old_performer_id = @task.performer.id
    update_value = params.require(:task).permit(:description, :performer, :state)
    update_value[:performer] = User.find(update_value[:performer].to_i)
    @task.update_attributes(update_value)
    new_performer_id = @task.performer.id
    $redis.publish('task.update', [@task, old_performer_id, new_performer_id].to_json)
    respond_to do |format|
     format.js
    end
  end

  def update_live
    data = params["upd_data"]
    @task = Task.find(data)
    respond_to do |format|
     format.js
    end
  end

  def events
    response.headers['Content-Type'] = 'text/event-stream'
    redis = Redis.new
    redis.psubscribe('task.*') do |on|
      on.pmessage do |pattern, event, data|
        if event == "task.create"
          task = ActiveSupport::JSON.decode(data)
          if @current_user.id == task["performer"]["id"] && task["performer"]["id"] != task["user_id"]
            sse = SSE.new(response.stream, retry: 300, event: "event-create")
            sse.write(task["id"])
            sse.close
          end
        elsif event == "task.update"
          array = ActiveSupport::JSON.decode(data)
          task = array.first
          old_u = array[1]
          new_u = array[2]

          p "User old = #{old_u}"
          p "User new = #{new_u}"
          if @current_user.id == task["performer"]["id"] || @current_user.id == task["user_id"] || @current_user.id == old_u
            sse = SSE.new(response.stream, retry: 300, event: "event-update")
            sse.write(task["id"])
            sse.close
          end
        elsif event == "task.delete"
          task = ActiveSupport::JSON.decode(data)
          if @current_user.id == task["performer"]["id"] || @current_user.id == task["user_id"]
            sse = SSE.new(response.stream, retry: 300, event: "event-delete")
            sse.write(task["id"])
            sse.close
          end
        end
      end
    end


  ensure
    redis.quit
  end


private

  def find_task_and_users
    @users = User.all
    @task = Task.find(params[:id])
  end
end
#SELECT *FROM USERS WHERE email = :email
