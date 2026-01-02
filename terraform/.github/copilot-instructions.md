# Copilot / AI agent instructions — Terraform infra (Portuguese repo)

Purpose
- Short: help AI contributors be productive with this Terraform infra repository.

Quick facts
- Terraform project using an S3 remote state backend: see [backend.tf](backend.tf#L1).
- AWS provider pinned to >=4.0 and region `us-east-2`: see [provider.tf](provider.tf#L1).
- Many environment/component variable files use the `*.auto.tfvars` pattern (e.g. `ecs.auto.tfvars`, `banco-de-dados.auto.tfvars`) and are auto-loaded by Terraform.

Big picture
- Root-level Terraform orchestrates multiple feature modules under `modulos/` (Portuguese names: `Aplicacao`, `Armazenamento`, `Banco_de_dados`, `Conectividade`, `Frontend`, etc.).
- Each module contains `dev/` and `prod/` subfolders and implements AWS resources (ECS, RDS, S3, CloudFront, Transit Gateway, Security Groups, etc.).
- The repo layout intentionally separates environment-specific inputs into `.auto.tfvars` files so Terraform CLI invoked at the repo root can compose the full plan.

Key files to consult (examples)
- `provider.tf` — provider & region ([provider.tf](provider.tf#L1)).
- `backend.tf` — S3 backend bucket/key ([backend.tf](backend.tf#L1)).
- `variables.tf` — large, single canonical variable list (many RDS/ECS vars) ([variables.tf](variables.tf#L1)).
- `cloudwatch-logs.tf`, `ecs.tf`, `ecs.auto.tfvars` — ECS logging and runtime config; see troubleshooting in `TROUBLESHOOTING_ECS.md` ([TROUBLESHOOTING_ECS.md](TROUBLESHOOTING_ECS.md#L1)).

Developer workflows to assume
- Init and plan from repo root:
```
terraform init
terraform plan
```
- State is stored in S3 (`rodrigo-desafio-ezops-tfstate`, key `main/terraform.tfstate`) — ensure AWS credentials and correct profile are set before `init`/`apply`.
- `*.auto.tfvars` are automatically loaded; do not pass them explicitly unless you want to override behavior with `-var-file`.
- For ECS debug, use the commands listed in `TROUBLESHOOTING_ECS.md` (CloudWatch tail, `aws ecs describe-tasks`, ECR `describe-images`).

Project-specific conventions and gotchas
- Folder name `modulos/` and variable names are in Portuguese — mirror naming when creating new modules/vars.
- Modules have `dev/` and `prod/` variants. Prefer editing module code under `modulos/*/<component>/` for shared behavior.
- Many Terraform variables are declared centrally in `variables.tf` (RDS, ECS, SGs). When adding new features, add vars there and provide corresponding `*.auto.tfvars` for environments.
- CloudWatch Log Group names and ECS cluster/service names are hard-coded in troubleshooting docs (e.g., cluster `rodrigo-ecs-cluster`, service `rodrigo-backend-service`, log group `/ecs/rodrigo-backend`). Use these exact names when searching logs.

Integration points
- S3 (remote state), ECR (images), RDS, CloudWatch Logs, ALB/ECS, Transit Gateway — changes to one area often require updating related module inputs (e.g., RDS endpoint used by ECS tasks; see `ecs.auto.tfvars`).

What I (the AI) should do first when making edits
- Run `terraform init` locally (ensure creds) and a focused `terraform plan` for the scope you change.
- Update `variables.tf` when adding new inputs and include matching `*.auto.tfvars` for dev/prod.
- Keep naming consistent with Portuguese module names and tags (avoid mixing `modules` vs `modulos`).

If something is ambiguous
- Prefer small, reversible changes with clear `terraform plan` output. Ask the human if unsure about environment-specific values (secrets, usernames, RDS passwords).

References
- See `TROUBLESHOOTING_ECS.md` for concrete ECS/ECR/CloudWatch commands and cluster/service names ([TROUBLESHOOTING_ECS.md](TROUBLESHOOTING_ECS.md#L1)).

Feedback
- If any section is unclear or you want additional examples (module lifecycle, tagging conventions, or a sample `ecs.auto.tfvars`), tell me which area to expand.
