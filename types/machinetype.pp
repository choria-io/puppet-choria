# @summary Choria machine (autonomous agent) type
type Choria::MachineType = Struct[{
    "version"       => String,
    "initial_state" => String[1],
    "transitions"   => Array[Hash],
    "watchers"      => Array[Hash],
    "ensure"        => Optional[Enum["present", "absent"]],
}]
