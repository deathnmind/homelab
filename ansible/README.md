# ansible
ansible files for examples

If you run the ansible playbook without `extravars` it will run against the ubuntu group in the inventory.  If you run the playbook with `--extra-vars "variable_host=test_server"` it will run against the system defined in the `extravars` variable.

