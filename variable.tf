variable "app_name" {
  type = string
  default = "sample"
}

# AZ の設定(冗長化のため配列でlist化してある)
variable "azs" {
  type = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "LOKI_USER" {
  type = string
}

variable "LOKI_PASS" {
  type = string
}

# RDS で使用
variable "DB_NAME" {
  type = string
}

variable "DB_MASTER_NAME" {
  type = string
}

variable "DB_MASTER_PASS" {
  type = string
}