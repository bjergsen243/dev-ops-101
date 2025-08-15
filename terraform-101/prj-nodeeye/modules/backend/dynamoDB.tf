resource "aws_dynamodb_table" "floor_table" {
  name           = "FloorTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  range_key      = "area_id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "area_id"
    type = "S"
  }
}
