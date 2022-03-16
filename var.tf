variable "nom_host" {
  type = string
  default = "worker"
}

variable "nom_domini" {
  type    = string
  default = "just4fun.edu"
}

variable "nombre_instancies" {
  type = number
  default = 3
}

variable "account" {
  ## scalable in multiuser environments
  type    = string
  default = "changeme"
}

variable "project" {
  description = "correspondència entre instàncies i configuració"
  # el camp <user_data_file> no se fa servir de moment 
  type        = map(any)
  default = {
    mysql_app = {
      memory         = "2048",
      hostname       = "mysql",
      element        = 1
    },
    nextcloud_app = {
      memory         = "1024",
      hostname       = "nextcloud",
      element        = 0
    },
    minio_app = {
      memory         = "1024",
      hostname       = "minio",
      element        = 2
    }
  }
}

