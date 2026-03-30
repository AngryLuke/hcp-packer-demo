variable "region" {
    default = "eu-west-1"
}
variable "instance_type" {
    default = "t3.small"
}
variable "instance_name" {
    default = "simple-web-server"
}
variable "environment" {
    default = "production"
}
variable "owner" {
    default = "lbolli"
}
variable "cost_center" {
    default = "app-demo"
}
variable "extra" {
    default = "test-packer"
}