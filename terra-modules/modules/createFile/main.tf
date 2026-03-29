resource "local_file" "dummy" {
  content  = <<EOF
    Hello world
    module path: ${path.module}
    workspace: ${terraform.workspace}
    root module path: ${path.root}
    work dir: ${path.cwd}
    EOF

  # filename = "${path.module}/${var.file_name}"
  filename = "${path.cwd}/${var.file_name}"
}