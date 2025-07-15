data "aws_secretsmanager_secret" "docdb_secret" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "docdb_secret_version" {
  secret_id = data.aws_secretsmanager_secret.docdb_secret.id
}

module "vpc" {
  source          = "../../modules/vpc" #vpc module path
  vpc_name        = var.vpc_name        # Name of the VPC
  vpc_cidr        = var.vpc_cidr        # CIDR block for the VPC
  azs             = var.azs             # Availability Zones for the VPC
  private_subnets = var.private_subnets # Private Subnets for the VPC
  public_subnets  = var.public_subnets  # Public Subnets for the VPC
  environment     = var.environment     # Environment 
}

module "documentdb" {
  source = "../../modules/documentdb"
  vpc_id                   = module.vpc.vpc_id 
  app-security-group       = module.eks.node_security_group_id
  subnet_group_name        = var.docdb_subnet_group_name
  subnet_ids               = module.vpc.private_subnets
  cluster_identifier       = var.docdb_cluster_identifier
  master_username         = jsondecode(data.aws_secretsmanager_secret_version.docdb_secret_version.secret_string)["MONGO_INITDB_ROOT_USERNAME"]
  master_password         = jsondecode(data.aws_secretsmanager_secret_version.docdb_secret_version.secret_string)["MONGO_INITDB_ROOT_PASSWORD"]
  backup_retention_period  = var.docdb_backup_retention
  preferred_backup_window  = var.docdb_backup_window
  instance_class           = var.docdb_instance_class
  instance_count           = var.docdb_instance_count
  storage_encrypted        = var.docdb_encrypted
  tags                     = {
    Environment = var.environment
    Terraform   = "true"
  }
}

module "secrets_manager" {
  source = "../../modules/secret-manager"
  create_secret =  var.create_secret    # this will be true upon first time running terraform apply
  secret_name        = var.secret_name 
  secret_description = var.secret_description
  secret_string = jsonencode({
    MONGO_INITDB_ROOT_USERNAME = var.MONGO_INITDB_ROOT_USERNAME
    MONGO_INITDB_ROOT_PASSWORD = var.MONGO_INITDB_ROOT_PASSWORD
    MONGO_INITDB_DATABASE      = var.MONGO_INITDB_DATABASE
    MONGODB_URI                = module.documentdb.docdb_cluster_endpoint
  })

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

module "eks" {
  source           = "../../modules/eks"        # EKS module path
  cluster_name     = var.cluster_name           # Name of the EKS cluster
  cluster_version  = var.cluster_version        # Version of the EKS cluster
  vpc_id           = module.vpc.vpc_id          # VPC ID for the EKS cluster
  subnet_ids       = module.vpc.private_subnets # Subnet IDs for the EKS cluster
  public_subnets   = module.vpc.public_subnets  # Public Subnet IDs for the EKS cluster
  min_size         = var.min_size               # Minimum node count in ASG
  max_size         = var.max_size               # Maximum node count in ASG
  desired_size     = var.desired_size           # Desired node count in ASG
  instance_types   = var.instance_types         # Instance types for EKS nodes
  ami_type         = var.ami_type               # AMI type for EKS nodes
  node_group_label = var.node_group_label       # Node group label
  environment      = var.environment            # Environment for the EKS cluster
}

module "efs" {
  source         = "../../modules/efs"        # EFS module path
  efs_name       = var.efs_name               # Name of the EFS
  vpc_id         = module.vpc.vpc_id          # VPC ID for the EFS
  vpc_cidr_block = var.vpc_cidr_block         # CIDR block for the VPC
  subnet_ids     = module.vpc.private_subnets # Subnet IDs for the EFS
  environment    = var.environment            # Environment for the EFS
}

module "acm" {
  source      = "../../modules/acm"            # ACM module path
  domain_name = var.domain_name                # Domain name for the ACM certificate
  zone_id     = module.route53.route53_zone_id # Route53 zone ID for the ACM certificate
}

module "route53" {
  source       = "../../modules/route53"            # Route53 module path
  domain_name  = var.domain_name                    # Domain name for Route53
  alb_dns_name = module.alb_controller.alb_dns_name # DNS name for the ALB 
  alb_zone_id  = module.alb_controller.alb_zone_id  #  Zone ID for the ALB
}

module "alb_controller" {
  source           = "../../modules/alb"                           # ALB module path
  cluster_name     = module.eks.cluster_name                       # Name of the EKS cluster
  cluster_endpoint = module.eks.cluster_endpoint                   # Endpoint for the EKS cluster
  cluster_ca       = module.eks.cluster_certificate_authority_data # Certificate authority data for the EKS cluster
  aws_region       = var.aws_region                                # AWS region for the ALB controller
}

module "waf" {
  source = "../../modules/waf" # WAF module path

  name         = var.waf_name                  # Name of the WAF ACL
  resource_arn = module.alb_controller.alb_arn # ARN of the ALB
  rate_limit   = var.rate_limit                # Rate limit (requests per 5 min)
}
