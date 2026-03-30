data "hcp_packer_version" "app-production" {
  bucket_name  = "app"
  channel_name = var.environment
}

data "hcp_packer_artifact" "app-production-eu-west" {
  bucket_name         = data.hcp_packer_version.app-production.bucket_name
  version_fingerprint = data.hcp_packer_version.app-production.fingerprint
  platform            = "aws"
  region              = var.region
}

resource "aws_instance" "web-server-app" {
  ami                    = data.hcp_packer_artifact.app-production-eu-west.external_identifier
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_webserver_traffic.id]

  lifecycle {
      # Controllo preventivo: evita di avviare una VM incompatibile (risparmio costi/tempo)
      # precondition {
      #   # Usiamo lookup per evitare il crash se la chiave "architecture" manca
      #   condition = lookup(data.hcp_packer_artifact.app-production-eu-west.labels, "architecture", "") == (strcontains(var.instance_type, "g") ? "arm64" : "x86_64")
        
      #   error_message = format(
      #     "Incompatibilità Architettura: L'AMI su HCP Packer è %s, ma l'istanza %s richiede %s.",
      #     lookup(data.hcp_packer_artifact.app-production-eu-west.labels, "architecture", "SCONOSCIUTA"),
      #     var.instance_type,
      #     (strcontains(var.instance_type, "g") ? "arm64" : "x86_64")
      #   )
      # }
      # Controllo post-creazione: verifica la configurazione reale su AWS
      # La postcondition verifica che l'attributo self.ami (l'ID dell'AMI utilizzata) 
      # sia identico all'ID dell'artefatto recuperato dal Registry di HCP Packer
      postcondition {
        condition     = self.ami == data.hcp_packer_artifact.app-production-eu-west.external_identifier
        error_message = "Must use the latest available AMI, ${data.hcp_packer_artifact.app-production-eu-west.external_identifier}."
      }
  }
  tags = {
    Name = "${var.instance_name}-web"
    Environment = "${var.environment}"
    CostCenter = "${var.cost_center}"
    Owner = "${var.owner}-web"
    Test = "${var.extra}-web"
  }
}

