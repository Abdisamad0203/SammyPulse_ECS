module "network" {
  source = "./modules/network"
}

module "alb" {
  source = "./modules/alb"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids
  alb_sg_id  = module.network.alb_sg_id
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source = "./modules/ecs"

  subnet_ids       = module.network.public_subnet_ids
  ecs_sg_id        = module.network.ecs_sg_id
  target_group_arn = module.alb.target_group_arn
  repository_url   = module.ecr.repository_url
}
