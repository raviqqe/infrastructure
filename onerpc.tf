module "onerpc_repository" {
  source = "./modules/github_repository"

  name         = "oneRPC"
  description  = "The router-less serverless RPC framework for TypeScript"
  homepage_url = "https://raviqqe.github.io/oneRPC"
  topics = [
    "aws-lambda",
    "edge-computing",
    "nextjs",
    "rpc",
    "typescript",
  ]
  private = false
}
