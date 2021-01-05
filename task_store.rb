require "./task.rb"

class TaskStore
  TASK_STORE_PATH = "./task_store.csv"
  HEADERS = ["id", "due_on", "name", "state"]

  def initialize(due_on, task_name)
    @tasks = get_tasks
    @target_task = Task.new(get_id, due_on, task_name)
  end

  def add_task
    push_task(@target_task)
  end

  def delete_task
    refresh_store
    add_tasks(get_rejected_task)
  end

  def show_daily_tasks
    @target_task.show_due_on
    @tasks
      .select { |task| task.due_on == @target_task.due_on }
      .each(&:show_name_and_state)
  end

  def show_all_tasks
    @tasks
      .group_by { |task| task.due_on }
      .each do |due_on, tasks|
        puts "", due_on
        tasks.each(&:show_name_and_state)
      end
  end

  def change_task_state
    raise "タスクは完了しています" if @tasks[find_task_id - 1].is_done?

    @tasks.each do |task|
      task.change_state if task.id == find_task_id
    end
    refresh_store
    add_tasks(@tasks)
  end

  def delete_done_tasks
    @tasks.reject! { |task| task.is_done? }
    refresh_store
    add_tasks(@tasks)
  end

  def delete_before_tasks
    @tasks.reject! { |task| task.is_past? }
    refresh_store
    add_tasks(@tasks)
  end

  private

  def get_tasks
    CSV
      .read(TASK_STORE_PATH, headers: true)
      .map { |task| Task.new(task["id"], task["due_on"], task["name"], task["state"]) }
      .sort_by { |task| task.due_on }
  end

  def get_rejected_task
    @tasks.reject { |task| task.id == find_task_id }
  end

  def get_id
    @tasks.last.id + 1
  end

  def push_task(task)
    CSV.open(TASK_STORE_PATH, mode = "a") do |store| 
      store.puts [task.id, task.due_on, task.name, task.state]
    end
  end

  def find_task
    @tasks.find { |task| task.due_on == @target_task.due_on && task.name == @target_task.name }
  end

  def find_task_id
    raise "タスクが見つかりません" if find_task.nil?

    find_task.id
  end

  def refresh_store
    CSV.open(TASK_STORE_PATH, mode = "a") do |store| 
      store.truncate(0)
      store.puts HEADERS
    end
  end

  def add_tasks(tasks)
    tasks.each_with_index do |task, i|
      task.id = i + 1
      push_task(task)
    end
  end
end
