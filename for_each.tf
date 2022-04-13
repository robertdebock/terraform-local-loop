# First make a map relating a filename with content.
locals {
  file_map = {
    file1 = "hello"
    file2 = "world"
  }
}

# Now create files using the for_each meta argument.
resource "local_file" "foreach" {
  for_each = local.file_map
  filename = "${path.module}/files/${each.key}.bar"
  content  = each.value
}

# Now read the created files.
# Not that each.value is not applicable, we only need to read the file.
data "local_file" "foreach" {
  for_each = local.file_map
  filename = "${path.module}/files/${each.key}.bar"
  # Terraform can only read files once they are created.
  depends_on = [ local_file.foreach ]
}

# Showing data from a resource using for_each requires a for-loop.
output "foreach" {
  value = {
    # This reads `data.local_file.foreach` as a key-value pair.
    for key, value in data.local_file.foreach : key => value.content
  }
}

output "splat" {
  value = data.local_file.foreach[*]
}
