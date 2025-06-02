locals {
  lambda_permissions = {
    get_all_authors = {
      function_name = aws_lambda_function.get_all_authors.function_name
      function_arn  = "${var.aws_api_gateway_rest_api}/*/GET"
      statement_id  = "AllowGetAllAuthors"
    },
    get_all_courses = {
      function_name = aws_lambda_function.get_all_courses.function_name
      function_arn  = "${var.aws_api_gateway_rest_api}/*/GET"
      statement_id  = "AllowGetAllCourses"
    },
    delete_course = {
      function_name = aws_lambda_function.delete_course.function_name
      function_arn  = "${var.aws_api_gateway_rest_api}/*/DELETE"
      statement_id  = "AllowDeleteCourses"
    },
    get_course = {
      function_name = aws_lambda_function.get_course.function_name
      function_arn  = "${var.aws_api_gateway_rest_api}/*/GET"
      statement_id  = "AllowGetCourse"
    },
    save_course = {
      function_name = aws_lambda_function.save_course.function_name
      function_arn  = "${var.aws_api_gateway_rest_api}/*/POST"
      statement_id  = "AllowSaveCourses"
    },
    update_course = {
      function_name = aws_lambda_function.update_course.function_name
      function_arn  = "${var.aws_api_gateway_rest_api}/*/PUT"
      statement_id  = "AllowUpdateCourses"
    }
  }
}

output "lambda_permissions" {
  value = local.lambda_permissions
}

output "get_all_authors_invoke_arn" {
  value = aws_lambda_function.get_all_authors.invoke_arn
}

output "get_all_courses_invoke_arn" {
  value = aws_lambda_function.get_all_courses.invoke_arn
}

output "post_save_course_invoke_arn" {
  value = aws_lambda_function.save_course.invoke_arn
}
output "put_update_course_invoke_arn" {
  value = aws_lambda_function.update_course.invoke_arn
}

output "get_course_by_id_invoke_arn" {
  value = aws_lambda_function.get_course.invoke_arn
}
output "delete_course_by_id_invoke_arn" {
  value = aws_lambda_function.delete_course.invoke_arn
}

output "lambda_function_names" {
  value = [aws_lambda_function.delete_course.function_name, aws_lambda_function.get_course.function_name, aws_lambda_function.update_course.function_name,
  aws_lambda_function.save_course.function_name, aws_lambda_function.get_all_courses.function_name, aws_lambda_function.get_all_authors.function_name]
}