aws_region            = "us-east-1"
vpc_name              = "eks-vpc"
vpc_cidr              = "10.0.0.0/16"
azs                   = ["us-east-1a", "us-east-1b", "us-east-1c"]
private_subnets       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets        = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
cluster_name          = "cluster"
cluster_version       = "1.32"
instance_types        = ["m6g.large"]
ami_type              = "AL2023_ARM_64_STANDARD"
min_size              = 3
max_size              = 5
desired_size          = 3
node_group_label      = "web-app-node-group"
efs_name              = "eks-efs"
vpc_cidr_block        = ["10.0.0.0/16"]
environment           = "dev"
domain_name           = "example.com"
waf_name              = "web-app-waf"
prometheus_chart_name = "kube-prometheus-stack"
monitoring_namespace  = "monitoring"
rate_limit            = 10000
docdb_subnet_group_name  = "docdb-subnet-group-dev"
docdb_cluster_identifier = "docdb-cluster-dev"
docdb_username           = "docdbadmin"
docdb_password           = "SuperSecretPass123!"   # In real cases, use Secrets Manager reference
docdb_backup_retention   = 5
docdb_backup_window      = "03:00-04:00"
docdb_instance_class     = "db.t4g.medium"
docdb_instance_count     = 1
docdb_encrypted          = true
secret_name              = "demo-devops"
secret_description       = "secrets storing mongo db credentials"
MONGO_INITDB_ROOT_USERNAME = "admin"
MONGO_INITDB_ROOT_PASSWORD = "password"
MONGO_INITDB_DATABASE      = "secureapp"
create_secret = true    #this value be false upon running terraform apply post first time