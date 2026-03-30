resource "hcp_packer_bucket" "base-image" {
  name = "base-image"
}

resource "hcp_packer_channel" "base-staging" {
  name        = "staging"
  bucket_name = "base-image"

  depends_on = [hcp_packer_bucket.base-image]
}

resource "hcp_packer_channel" "base-prod" {
  name        = "production"
  bucket_name = "base-image"

  depends_on = [hcp_packer_bucket.base-image]
}

resource "hcp_packer_bucket" "app" {
  name = "app"
}

resource "hcp_packer_channel" "app-staging" {
  name        = "staging"
  bucket_name = "app"

  depends_on = [hcp_packer_bucket.app]
}

resource "hcp_packer_channel" "app-prod" {
  name        = "production"
  bucket_name = "app"

  depends_on = [hcp_packer_bucket.app]
}

# Create a channel for the app image, which will be used in the deployment phase
resource "hcp_packer_bucket" "alpine-base" {
  name = "alpine"
}

resource "hcp_packer_channel" "alpine-base-staging" {
  name        = "staging"
  bucket_name = "alpine"

  depends_on = [hcp_packer_bucket.alpine-base]
}

resource "hcp_packer_channel" "alpine-base-prod" {
  name        = "production"
  bucket_name = "alpine"

  depends_on = [hcp_packer_bucket.alpine-base]
}

resource "hcp_packer_bucket" "alpine-app" {
  name = "alpine-app"
}

resource "hcp_packer_channel" "alpine-app-staging" {
  name        = "staging"
  bucket_name = "alpine-app"

  depends_on = [hcp_packer_bucket.alpine-app]
}

resource "hcp_packer_channel" "alpine-app-prod" {
  name        = "production"
  bucket_name = "alpine-app"

  depends_on = [hcp_packer_bucket.alpine-app]
}