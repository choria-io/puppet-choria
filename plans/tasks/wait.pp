# Waits for a task to complete on all nodes
#
# @param task_id The task ID to check
# @param nodes The nodes to check the task on
# @param tries How many times to perform the check before failing
# @param sleep How long to wait between checks
# @return [Boolean] indicates task completion
plan acme::tasks::wait (
  String $task_id,
  Choria::Nodes $nodes,
  Integer $tries = 90,
  Integer $sleep = 20
) {
  info("Waiting for task ${task_id} to complete on ${nodes.size} nodes")

  range(1, $tries).each |$try| {
    $results = choria::task(
      "nodes"      => $nodes,
      "action"     => "bolt_tasks.task_status",
      "silent"     => true,
      "pre_sleep"  => $sleep,
      "properties" => {
        "task_id"  => $task_id
      }
    )

    $completed = $results.map |$result| {
      $result["data"]["completed"]
    }

    unless false in $completed {
      info("Task ${task_id} completed after ${try} checks")
      return true
    }

    $running = $completed.filter |$c| { $c == false }

    unless $try == $tries {
      warning("Waiting for ${running.size} node(s) to complete task ${task_id} check ${try} / ${tries}")
    }
  }

  err("Task ${task_id} did not complete after ${tries} checks")

  return false
}
