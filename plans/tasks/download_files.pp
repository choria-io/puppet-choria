# Download the files of associated with a task onto the nodes
#
# @param nodes The nodes to download onto
# @param files The files section of the task metadata
# @param task The name of the task
# @return [Choria::TaskResults]
plan choria::tasks::download_files(
  String $task,
  Array[Hash] $files,
  Choria::Nodes $nodes
) {
  info("Downloading files for task '${task}' onto ${nodes.size} nodes")

  choria::task(
    "nodes"            => $nodes,
    "action"           => "bolt_tasks.download",
    "batch_size"       => 50,
    "batch_sleep_time" => 1,
    "silent"           => true,
    "properties"       => {
      "environment"    => "production",
      "task"           => $task,
      "files"          => $files.to_json
    }
  )
}
