provider "aws" {
  region  = "eu-central-1"
  version = "~> 3.20.0"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "testterrastate-3113"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstates"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}