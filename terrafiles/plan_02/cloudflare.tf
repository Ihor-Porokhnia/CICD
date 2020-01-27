provider "cloudflare" {
  version = "~> 2.0"
}

resource "cloudflare_record" "root" {

  count   = "${var.instance_count}"
  zone_id = "cb31e9f86a3d9b6579e64701c6e4a95b"
  name    = "@"
  value   = "${element(aws_instance.node.*.public_ip, count.index)}"
  type    = "A"
  proxied = false

}
resource "cloudflare_record" "inst" {

  count   = "${var.instance_count}"
  zone_id = "cb31e9f86a3d9b6579e64701c6e4a95b"
  name    = "inst${count.index + 1}"
  value   = "${element(aws_instance.node.*.public_ip, count.index)}"
  type    = "A"
  proxied = false
}
