variable "iam_entities" {
  description = "A map of IAM entities to create."
  type = map(object({
    name   = string
    policy = string
  }))
  default = {
    "entity1" = {
      name   = "Name1",
      policy = "Policy1"
    },
    "entity2" = {
      name   = "Name2",
      policy = "Policy2"
    }
  }
}
