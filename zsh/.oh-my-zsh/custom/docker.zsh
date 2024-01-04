alias d-clean-unused-volumes="d volume rm \$(d volume ls -q | grep -v - | grep -v _)"
alias d-prune="d system prune -f"
