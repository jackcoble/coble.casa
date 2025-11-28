output "complex-yaml" {
    value = provider::sops::file("../secrets/secrets.yaml")
}