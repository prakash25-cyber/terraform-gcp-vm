### Reference `main.tf` Code

In case you need the updated Terraform block that includes the project creation and API enablement:

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Provider configuration
provider "google" {
  region = "us-central1"
  zone   = "us-central1-a"
}

# 1. Create a new GCP Project
resource "google_project" "glowkart_project" {
  name       = "Glowkart Project"
  project_id = "glowkart-infra-unique-id" # Must be globally unique
  # billing_account = "XXXXXX-XXXXXX-XXXXXX" # Required if creating a project from scratch
}

# 2. Enable the Compute Engine API on the project
resource "google_project_service" "compute_api" {
  project = google_project.glowkart_project.project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

# 3. Create the Compute VM Instance
resource "google_compute_instance" "default" {
  project      = google_project.glowkart_project.project_id
  name         = "my-first-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  # Ensures Compute Engine API is active before attempting to create the VM
  depends_on = [google_project_service.compute_api]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
}

output "project_id" {
  value = google_project.glowkart_project.project_id
}

output "instance_name" {
  value = google_compute_instance.default.name
}

output "external_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
