# Retrieves the status of a task from a set of nodes
#
# Should any of the nodes not have run the task the task
# status retrival will fail unless fail_ok is true
#
# @param task_id The task ID to retrieve
# @param nodes The nodes to fetch the id from
# @param fail_ok When true failure to fetch the status from some nodes will not result in a playbook failure
# @return [Choria::TaskResults]
plan choria::tasks::status (
  String $task_id,
  Choria::Nodes $nodes,
  Boolean $fail_ok = false
) {
  info("Retrieving task status of task ${task_id} from ${nodes.size} nodes")

  choria::task(
    "nodes"      => $nodes,
    "action"     => "bolt_tasks.task_status",
    "silent"     => true,
    "fail_ok"    => $fail_ok,
    "properties" => {
      "task_id"  => $task_id
    }
  )
}
