resource "aws_imagebuilder_component" "cis_ansible" {
  name     = "cis-level-1-ansible"
  platform = "Linux"
  version  = "1.0.0"
  description = "Component that installs Ansible and applies CIS Level 1 playbook"
  data = <<COMP
name: cis-ansible
description: Install Ansible and run CIS Level 1 playbook
schemaVersion: 1.0
phases:
  - name: build
    steps:
      - name: install-packages
        action: ExecuteBash
        inputs:
          commands:
            - yum install -y python3
            - pip3 install ansible
      - name: create-playbook
        action: ExecuteBash
        inputs:
          commands:
            - cat <<'SCRIPT' >/tmp/cis-level1.yml
              - hosts: localhost
                gather_facts: true
                tasks:
                  - name: Sample CIS step
                    command: echo "CIS Level 1 placeholder"
            - SCRIPT
      - name: run-playbook
        action: ExecuteBash
        inputs:
          commands:
            - ansible-playbook /tmp/cis-level1.yml
COMP
}
