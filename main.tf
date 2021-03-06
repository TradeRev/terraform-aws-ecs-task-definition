locals {
  command               = "${jsonencode(var.command)}"
  dnsSearchDomains      = "${jsonencode(var.dnsSearchDomains)}"
  dnsServers            = "${jsonencode(var.dnsServers)}"
  dockerLabels          = "${jsonencode(var.dockerLabels)}"
  dockerSecurityOptions = "${jsonencode(var.dockerSecurityOptions)}"
  entryPoint            = "${jsonencode(var.entryPoint)}"
  environment           = "${jsonencode(var.environment)}"
  extraHosts            = "${jsonencode(var.extraHosts)}"

  healthCheck = "${
    replace(
      jsonencode(var.healthCheck),
      local.classes["digit"],
      "$1"
    )
  }"

  links = "${jsonencode(var.links)}"

  linuxParameters = "${
    replace(
      replace(
        replace(
          jsonencode(var.linuxParameters),
          "/\"1\"/",
          "true"
        ),
        "/\"0\"/",
        "false"
      ),
      local.classes["digit"],
      "$1"
    )
  }"

  logConfiguration = "${jsonencode(var.logConfiguration)}"

  mountPoints = "${
    replace(
      replace(
        jsonencode(var.mountPoints),
        "/\"1\"/",
        "true"
      ),
      "/\"0\"/",
      "false"
    )
  }"

  portMappings = "${
    replace(
      jsonencode(var.portMappings),
      local.classes["digit"],
      "$1"
    )
  }"

  repositoryCredentials = "${jsonencode(var.repositoryCredentials)}"
  resourceRequirements  = "${jsonencode(var.resourceRequirements)}"
  secrets               = "${jsonencode(var.secrets)}"
  systemControls        = "${jsonencode(var.systemControls)}"

  ulimits = "${
    replace(
      jsonencode(var.ulimits),
      local.classes["digit"],
      "$1"
    )
  }"

  volumesFrom = "${
    replace(
      replace(
        jsonencode(var.volumesFrom),
        "/\"1\"/",
        "true"
      ),
      "/\"0\"/",
      "false"
    )
  }"

  # re2 ASCII character classes
  # https://github.com/google/re2/wiki/Syntax
  classes = {
    digit = "/\"([[:digit:]]+)\"/"
  }

  container_definitions = "${replace(data.template_file.container_definitions.rendered, "/\"(null)\"/", "$1")}"
}

data "template_file" "container_definitions" {
  template = "${file("${path.module}/templates/container-definitions.json.tmpl")}"

  vars = {
    command                = "${local.command == "[]" ? "null" : local.command}"
    cpu                    = "${var.cpu == 0 ? "null" : var.cpu}"
    disableNetworking      = "${var.disableNetworking ? true : false}"
    dnsSearchDomains       = "${local.dnsSearchDomains == "[]" ? "null" : local.dnsSearchDomains}"
    dnsServers             = "${local.dnsServers == "[]" ? "null" : local.dnsServers}"
    dockerLabels           = "${local.dockerLabels == "{}" ? "null" : local.dockerLabels}"
    dockerSecurityOptions  = "${local.dockerSecurityOptions == "[]" ? "null" : local.dockerSecurityOptions}"
    entryPoint             = "${local.entryPoint == "[]" ? "null" : local.entryPoint}"
    environment            = "${local.environment == "[]" ? "null" : local.environment}"
    essential              = "${var.essential ? true : false}"
    extraHosts             = "${local.extraHosts == "[]" ? "null" : local.extraHosts}"
    healthCheck            = "${local.healthCheck == "{}" ? "null" : local.healthCheck}"
    hostname               = "${var.hostname == "" ? "null" : var.hostname}"
    image                  = "${var.image == "" ? "null" : var.image}"
    interactive            = "${var.interactive ? true : false}"
    links                  = "${local.links == "[]" ? "null" : local.links}"
    linuxParameters        = "${local.linuxParameters == "{}" ? "null" : local.linuxParameters}"
    logConfiguration       = "${local.logConfiguration == "{}" ? "null" : local.logConfiguration}"
    memory                 = "${var.memory == 0 ? "null" : var.memory}"
    memoryReservation      = "${var.memoryReservation == 0 ? "null" : var.memoryReservation}"
    mountPoints            = "${local.mountPoints == "[]" ? "null" : local.mountPoints}"
    name                   = "${var.name == "" ? "null" : var.name}"
    portMappings           = "${local.portMappings == "[]" ? "null" : local.portMappings}"
    privileged             = "${var.privileged ? true : false}"
    pseudoTerminal         = "${var.pseudoTerminal ? true : false}"
    readonlyRootFilesystem = "${var.readonlyRootFilesystem ? true : false}"
    repositoryCredentials  = "${local.repositoryCredentials == "{}" ? "null" : local.repositoryCredentials}"
    resourceRequirements   = "${local.resourceRequirements == "[]" ? "null" : local.resourceRequirements}"
    secrets                = "${local.secrets == "[]" ? "null" : local.secrets}"
    systemControls         = "${local.systemControls == "[]" ? "null" : local.systemControls}"
    ulimits                = "${local.ulimits == "[]" ? "null" : local.ulimits}"
    user                   = "${var.user == "" ? "null" : var.user}"
    volumesFrom            = "${local.volumesFrom == "[]" ? "null" : local.volumesFrom}"
    workingDirectory       = "${var.workingDirectory == "" ? "null" : var.workingDirectory}"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  container_definitions    = "${local.container_definitions}"
  execution_role_arn       = "${var.execution_role_arn}"
  family                   = "${var.family}"
  ipc_mode                 = "${var.ipc_mode}"
  network_mode             = "${var.network_mode}"
  pid_mode                 = "${var.pid_mode}"
  placement_constraints    = "${var.placement_constraints}"
  requires_compatibilities = "${var.requires_compatibilities}"
  task_role_arn            = "${var.task_role_arn}"
  volume                   = "${var.volumes}"
}
