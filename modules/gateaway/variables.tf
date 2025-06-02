variable "lambda_permissions" {
  type = map(object({
    function_name = string
    function_arn  = string
    statement_id  = string
  }))
}

variable "get_all_courses_invoke_arn" {}
variable "get_all_authors_invoke_arn" {}
variable "post_save_course_invoke_arn" {}
variable "put_update_course_invoke_arn" {}
variable "get_course_by_id_invoke_arn" {}
variable "delete_course_by_id_invoke_arn" {}