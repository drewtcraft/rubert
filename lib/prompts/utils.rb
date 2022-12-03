require_relative '../helpers/output'
require_relative '../helpers/input'


module GetTask
  def get_task
    args_hash = extract_args_hash

    task = if args_hash[:int_args].any?
      index = args_hash[:int_args].first
      Output.log "looking for task with index: #{index}"
      # TODO if @state.has_last_task_list
      @state.last_task_list[index]
    elsif args_hash[:string_args].any?
      id = args_hash[:string_args].first
      if id.match(/first/)
        @ledger.tasks.first
      elsif id.match(/last/)
        @ledger.tasks.last
      end
      Output.log "looking for task with ID: #{id}"
      @ledger.tasks.find{|r| r.id == id}
    end

    Output.log "task found!" if task

    task
  end
end
