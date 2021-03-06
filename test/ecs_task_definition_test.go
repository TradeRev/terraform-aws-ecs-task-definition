package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestContainerDefinitionsOutput(t *testing.T) {
	t.Parallel()
	options := &terraform.Options{
		NoColor:      true,
		TerraformDir: "..",
		VarFiles:     []string{"varfile.tfvars"},
	}
	defer terraform.Destroy(t, options)
	terraform.InitAndApply(t, options)
	expected :=
		`[
  {
    "command": null,
    "cpu": null,
    "disableNetworking": false,
    "dnsSearchDomains": null,
    "dnsServers": null,
    "dockerLabels": null,
    "dockerSecurityOptions": null,
    "entryPoint": null,
    "environment": [{"name":"AWS_DEFAULT_REGION","value":"us-east-1"}],
    "essential": true,
    "extraHosts": null,
    "healthCheck": {"command":["echo"],"interval":30,"retries":3,"startPeriod":0,"timeout":5},
    "hostname": null,
    "image": "mongo:3.6",
    "interactive": false,
    "links": null,
    "linuxParameters": {"capabilities":{"add":["AUDIT_CONTROL","AUDIT_WRITE"],"drop":["SYS_RAWIO","SYS_TIME"]},"devices":[{"containerPath":"/dev/disk0","hostPath":"/dev/disk0","permissions":["read"]}],"initProcessEnabled":true,"sharedMemorySize":512,"tmpfs":[{"containerPath":"/tmp","mountOptions":["defaults"],"size":512}]},
    "logConfiguration": null,
    "memory": null,
    "memoryReservation": 512,
    "mountPoints": [{"containerPath":"/dev/disk0","readOnly":true,"sourceVolume":"data"}],
    "name": "mongo",
    "portMappings": [{"containerPort":8080,"hostPort":0,"protocol":"tcp"}],
    "privileged": false,
    "pseudoTerminal": false,
    "readonlyRootFilesystem": false,
    "repositoryCredentials": null,
    "resourceRequirements": null,
    "secrets": null,
    "systemControls": null,
    "ulimits": [{"hardLimit":1024,"name":"cpu","softLimit":1024}],
    "user": "root",
    "volumesFrom": null,
    "workingDirectory": "~/project"
  }
]`
	actual := terraform.Output(t, options, "container_definitions")
	assert.Equal(t, expected, actual)
}
