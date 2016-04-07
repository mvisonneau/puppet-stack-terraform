resource "template_file" "bootstrap_puppetca" {
  template      = "${file("init/cloud-config.yml")}"

  vars {
    hostname    = "${var.vdc}-puppetca01"
    domain      = "${var.domain}"
  }
}

resource "template_file" "bootstrap_puppetdb" {
  template      = "${file("init/cloud-config.yml")}"
  count         = "${length( split( ",", lookup( var.azs, var.region ) ) )}"

  vars {
    hostname    = "${var.vdc}-puppetdb0${count.index+1}"
    domain      = "${var.domain}"
  }
}

resource "template_file" "bootstrap_jump" {
  template      = "${file("init/cloud-config.yml")}"

  vars {
    hostname    = "${var.vdc}-jump01"
    domain      = "${var.domain}"
  }
}
