variable "api_1_path" {
  type = string
}
variable "project_name" {
  type    = string  
}
variable "region" {
  type = string
}
variable "solution_stack" {
  type = string
}
variable "ssl_cert_arn" {
  type = string
}
variable "ssl2_cert_arn" {
  type = string
}
variable "account_id" {
  type = string
}
variable "func_path" {
  type = string
}
variable "front_s3_prefix" {
  type = string
}
variable "back_s3_prefix" {
  type = string
}
variable "upload_s3_prefix" {
  type = string
}
variable "zone_id" {
  type = string
}
variable "record_name" {
  type = string
}
variable "secret_backend" {
  type    = string  
}
variable "secret_role" {
  type    = string  
}
variable "conf_path_vault" {
  type    = string  
}
variable "root_domain" {
  type    = string  
}
variable "redirect_domain" {
  type    = string  
}