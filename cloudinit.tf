resource "template_file" "bootstrap_puppetca" {
  template      = "${file("cloudinit.yml")}"

  vars {
    hostname    = "${var.vdc}-puppetca01"
    domain      = "${var.domain}"
  }
}

resource "template_file" "bootstrap_puppetdb" {
  template      = "${file("cloudinit.yml")}"
  count         = "${length( split( ",", lookup( var.azs, var.region ) ) )}"

  vars {
    hostname    = "${var.vdc}-puppetdb0${count.index+1}"
    domain      = "${var.domain}"
  }
}

resource "template_file" "bootstrap_jump" {
  template      = "${file("cloudinit.yml")}"

  vars {
    hostname    = "${var.vdc}-jump01"
    domain      = "${var.domain}"
  }
}
