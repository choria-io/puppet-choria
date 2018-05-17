# Waits for a task to complete on all nodes
#
# A note about the use of `fail_ok`, this will instruct the system
# to not consider nodes that failed as part of the determination of
# completion and to assume the nodes that did respond well are representitive.
#
# This may have a undesired outcome where 1 completed node that is not
# failing can completely mask 999 failing nodes none of whome have completed.
# You need to use this flag with caution and be aware of the possible impact.
# It is therefor off by default.
#
# @param task_id The task ID to check
# @param nodes The nodes to check the task on
# @param tries How many times to perform the check before failing
# @param sleep How long to wait between checks
# @param fail_ok Allow some nodes to fail the actual check call
# @return [Boolean] indicates task completion
plan choria::tasks::wait (
  String $task_id,
  Choria::Nodes $nodes,
  Integer $tries = 90,
  Integer $sleep = 20,
  Boolean $fail_ok = false
) {
  info("Waiting for task ${task_id} to complete on ${nodes.size} nodes")

  range(1, $tries).each |$try| {
    $results = choria::task(
      "nodes"      => $nodes,
      "action"     => "bolt_tasks.task_status",
      "silent"     => true,
      "pre_sleep"  => $sleep,
      "fail_ok"    => $fail_ok,
      "properties" => {
        "task_id"  => $task_id
      }
    )

    $completed = $results.ok_set.map |$result| {
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
