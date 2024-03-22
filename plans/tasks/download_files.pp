# Download the files of associated with a task onto the nodes
#
# @param nodes The nodes to download onto
# @param files The files section of the task metadata
# @param task The name of the task
# @param tasks_environment The environment to find tasks
# @param catch_errors Whether to catch errors
# @return [Choria::TaskResults]
plan choria::tasks::download_files(
  String $task,
  Array[Hash] $files,
  Choria::Nodes $nodes,
  String[1] $tasks_environment = "production",
  Optional[Boolean] $catch_errors = undef,
) {
  info("Downloading files for task '${task}' onto ${nodes.size} nodes")

  choria::task(
    "nodes"            => $nodes,
    "action"           => "bolt_tasks.download",
    "batch_size"       => 50,
    "batch_sleep_time" => 1,
    "silent"           => true,
    "_catch_errors"    => $catch_errors,
    "properties"       => {
      "environment"    => $tasks_environment,
      "task"           => $task,
      "files"          => $files.stdlib::to_json
    }
  )
}
