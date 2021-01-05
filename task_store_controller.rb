require "./task_store.rb"

class TaskStoreController
  def initialize(action_name, task_due_on, task_name)
    @action_name = action_name
    @task_store = TaskStore.new(task_due_on, task_name)
  end

  def run_action
    case @action_name
    when "add"
      add_task
    when "delete"
      delete_task
    when "change"
      change_task_state
    when "show_d"
      show_daily_task
    when "show_a"
      show_all_tasks
    when "delete_d"
      delete_done_tasks
    when "delete_b"
      derete_before_tasks
    else
      usage
    end
  end

  private

  def add_task
    @task_store.add_task
  end
  
  def delete_task
    @task_store.delete_task
  end

  def change_task_state
    @task_store.change_task_state
  end

  def show_daily_task
    @task_store.show_daily_tasks
  end

  def show_all_tasks
    @task_store.show_all_tasks
  end

  def delete_done_tasks
    @task_store.delete_done_tasks
  end

  def derete_before_tasks
    @task_store.delete_before_tasks
  end

  def usage
    puts <<~EOS
      You can make to-do-list to use this tool!
      This tool usage: ruby task_store_controller <action_name> <target_task_due_on> <target_task_name>
      actions : add <target_task_due_on> <target_task_name>        Add target task to "task_store.csv".
                delete <target_task_due_on> <target_task_name>     Delete target task from "task_store.csv".
                change <target_task_due_on> <target_task_name>     Change target task state.
                show_d <target_task_due_on>                        Show daily tasks.
                show_a                                             Show all tasks.
                delete_d                                           Delete tasks you have done.
                delete_b                                           Delete past tasks.
    EOS
  end
end

if __FILE__ == $0
  TaskStoreController.new(ARGV[0], ARGV[1], ARGV[2]).run_action
end
