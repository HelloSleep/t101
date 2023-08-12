resource "aws_db_instance" "education" {
  identifier             = "${var.db_name}-${random_pet.random.id}"
  instance_class         = var.db_instance_class # 修正
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"

variable "db_name" {
  description = "Unique name to assign to RDS instance"
  default = "t101"
}

variable "db_instance_class" {
  type        = string
  description = "The type of database instance to create"
}