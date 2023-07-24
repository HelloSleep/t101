resource "local_file" "foo" {
  content  = upper("foo! bar!")
  filename = "${path.module}/foo.bar"
}