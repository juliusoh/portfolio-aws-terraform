variable "private_subnets" {
  description = "A comma separated list of private subnets inside the VPC"
  type        = string
  default     = "10.0.101.0/24,10.0.102.0/24,10.0.103.0/24"
}
variable "eks_subnets" {
  description = "A comma separated list of eks subnets inside the VPC"
  type        = string
  default     = "10.0.151.0/24,10.0.152.0/24,10.0.153.0/24"
}

variable "public_subnets" {
  description = "A comma separated list of public subnets inside the VPC"
  type        = string
  default     = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "stack_name" {
  description = "The name of the stack that will be used to tag all known AWS Entities"
  type        = string
  default     = "juliusoh"
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-west-2"
}

variable "MainRdsUser" {
  type = string

  default = "pos"
}

variable "MainRdsPassword" {
  type = string

  default = "00000000"
}

variable "MainRdsStorage" {
  description = "The RDS Space in GBs"
  type        = string

  default = "100"
}

variable "MainRdsDbSchema" {
  type = string

  default = "pos"
}

variable "MainRdsStorageType" {
  description = "The type of storage to be used by the database"
  default     = "gp2"
}

variable "MainRdsEngineVersion" {
  description = "The RDS Engine Version"
  default     = "14.6"
}

variable "MainRdsInstanceClass" {
  description = "The RDS Instance Size"
  type        = string

  default = "db.t3.micro"
}

variable "MainRdsMultiAZ" {
  description = "If RDS is in multiple zones"
  type        = string

  default = "false"
}

variable "MainRdsBackupRetention" {
  description = "The RDS backup retention in days"
  default     = 30
}

variable "MainRdsSkipFinalBackup" {
  description = "Skips the RDS backup if shutdown"
  type        = string

  default = "true"
}