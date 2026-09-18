#                                         terraform-gcp-vm
Provision VM by using the terraform code 

Desktop/
└── Glowkart/
    └── terraform-gcp-vm/
        └── main.tf


### 📌 What was done

1. **Configured GCP & VS Code:**
   - Fixed `gcloud` path issues on the remote machine by exporting `~/google-cloud-sdk/bin` to `PATH`.
   - Authenticated with Google Cloud using `gcloud auth login --update-adc`.
   - Connected VS Code with Google Cloud credentials.

2. **Installed Terraform:**
   - Downloaded and placed the standalone `terraform` binary into `~/google-cloud-sdk/bin/` so it runs from any terminal.

3. **Created Project Structure:**
   - Created folder: `Desktop/Glowkart/terraform-gcp-vm/`
   - Created configuration file: `main.tf`

4. **Infrastructure Code (`main.tf`):**
   - Configured `hashicorp/google` provider.
   - **Created GCP Project:** Defined `google_project` resource to provision a dedicated project (linked to billing account).
   - **Enabled Required APIs:** Defined `google_project_service` resource to automatically enable the `compute.googleapis.com` API before launching resources.
   - **Provisioned VM:** Defined `google_compute_instance` resource:
     - Machine type: `e2-micro`
     - OS: `debian-12`
     - Network: Attached to default VPC with external public IP
     - Dependency: Explicitly depends on the Compute API service being active (`depends_on`).
   - Added outputs for the created Project ID, Instance Name, and Public NAT IP.

5. **Deployment Commands:**
   ```bash
   cd ~/Desktop/Glowkart/terraform-gcp-vm
   terraform init
   terraform plan
   terraform apply
