# This is a "simple" resources that repeats a few times.
resource "local_file" "default" {
  count    = 3
  content  = "I am iteration ${count.index}."
  filename = "${path.module}/files/foo-${count.index}.bar"
}

# This reads the files created.
# The `count` meta-argument is exactly as long as how many files are created.
data "local_file" "default" {
  count    = length(local_file.default)
  filename = "${path.module}/files/foo-${count.index}.bar"
}

# You can show attributes of counted resources by using the 'splat' expression.
output "content" {
  value = data.local_file.default[*].content
}
