resource "aws_ecr_repository" "sammy_ecr" {
  name = "sammypulse"

  tags = {
    Name = "sammypulse"
  }
}
