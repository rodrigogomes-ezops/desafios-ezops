# ==========================================================
# SEGURANÇA (Security Groups)
# ==========================================================

# SG do Prometheus: Precisa acessar o Backend e ser acessado pelo Grafana
resource "aws_security_group" "prometheus_sg" {
  name        = "prometheus-sg"
  description = "Security Group for Prometheus"
  vpc_id      = module.vpc.vpc_id # Ajuste para a referência correta do seu módulo VPC

  # Saída para o Backend (Scraping)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Entrada do Grafana (porta 9090)
  ingress {
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [aws_security_group.grafana_sg.id] # Referencia circular, cuidado (use regras separadas se der erro)
  }
}

# SG do Grafana: Precisa ser acessado pelo ALB (ou público para teste)
resource "aws_security_group" "grafana_sg" {
  name        = "grafana-sg"
  description = "Security Group for Grafana"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Acesso Web ao Grafana (porta 3000)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Idealmente, restrinja ao seu IP ou ALB
  }
}

# ==========================================================
# PROMETHEUS (ECS Task & Service)
# ==========================================================

resource "aws_ecs_task_definition" "prometheus_task" {
  family                   = "prometheus-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::618889059366:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "prometheus"
      image     = "618889059366.dkr.ecr.us-east-2.amazonaws.com/prometheus:latest" # Use a imagem que criamos no Passo A
      essential = true
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/prometheus"
          "awslogs-region"        = "us-east-2"
          "awslogs-stream-prefix" = "prometheus"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "prometheus_service" {
  name            = "prometheus-service"
  cluster         = module.ecs_cluster.cluster_id # Referência ao seu cluster existente
  task_definition = aws_ecs_task_definition.prometheus_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets # Rodar em subnet privada
    security_groups  = [aws_security_group.prometheus_sg.id]
    assign_public_ip = false
  }
}

# ==========================================================
# GRAFANA (ECS Task & Service)
# ==========================================================

resource "aws_ecs_task_definition" "grafana_task" {
  family                   = "grafana-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::618889059366:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "grafana"
      image     = "618889059366.dkr.ecr.us-east-2.amazonaws.com/grafana:latest" # Imagem oficial
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      environment = [
        { name = "GF_SECURITY_ADMIN_PASSWORD", value = "admin" } # Mude isso em produção!
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/grafana"
          "awslogs-region"        = "us-east-2"
          "awslogs-stream-prefix" = "grafana"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "grafana_service" {
  name            = "grafana-service"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = aws_ecs_task_definition.grafana_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets # Publique se quiser acesso direto (ou Privada + ALB)
    security_groups  = [aws_security_group.grafana_sg.id]
    assign_public_ip = true # True se estiver na subnet pública para facilitar o acesso
  }
}