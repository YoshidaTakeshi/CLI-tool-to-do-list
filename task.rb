require "date"
require "csv"

class Task
  attr_accessor :name, :due_on, :id, :state

  TASK_STATE = {0 => "未着手", 1 => "進行中", 2 => "完了"}
  DEFAULT_DATE = "2000-01-01"

  def initialize(id, due_on, name, state = 0)
    @id = id.to_i
    @due_on = set_due_on(due_on)
    @name = name
    @state = state.to_i
  end

  def show_name_and_state
    puts "・#{@name}  [#{TASK_STATE[@state]}]"
  end

  def show_due_on
    puts "#{@due_on}"
  end

  def change_state
    @state += 1
  end

  def is_done?
    @state == 2
  end

  def is_past?
    @due_on < Date.today
  end

  private

  def set_due_on(due_on)
    return Date.parse(DEFAULT_DATE) if due_on.nil?

    Date.parse(due_on)
  end
end
