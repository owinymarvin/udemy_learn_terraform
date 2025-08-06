provider "aws" {
  region = "us-east-1"
}

# create an admin user
resource "aws_iam_user" "admin" {
  name = "dmarv_tf_admin"
  tags = {
    Description = "Technical Team Leader"
  }
  force_destroy = true
}

# create the policy to govern admin users
resource "aws_iam_policy" "adminPolicy" {
  name        = "adminUsers"
  description = "I am policy for admins"
  path        = "/"
  tags = {
    "permissions" : "all"
  }
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = "*"
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
    policy = file("admin-policy.json")
}

# create a policy attachment to attach the policy
# to the user (admin policy to admin user)
resource "aws_iam_user_policy_attachment" "admin_attachment" {
  user       = aws_iam_user.admin.name
  policy_arn = aws_iam_policy.adminPolicy.arn
}