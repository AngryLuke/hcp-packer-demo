# check "check_vm_status" {
#   data "aws_instance" "web-check" {
#   filter {
#     name   = "tag:Name"
#     values = ["${var.instance_name}-web"]
#   }

#   # Questo filtro esclude le istanze nello stato 'terminated' permettendo a Terraform di trovare l'unica istanza reale.
#   filter {
#     name   = "instance-state-name"
#     values = ["running"]
#   }
# }

#   # Note: in this example we reference the resource directly instead of using a data source (or a data source that is scoped to this check block)
 
#   assert {
#     condition = data.aws_instance.web-check.instance_state == "running"
#     error_message = format("Provisioned VMs should be in a RUNNING status, instead the VM `%s` has status: %s",
#       data.aws_instance.web-check.arn,
#       data.aws_instance.web-check.instance_state
#     )
#   }
# }