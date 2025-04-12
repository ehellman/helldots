# helldots


### packages


### TODO

- [ ] change repo structure into `/home` with `.chezmoiroot` to make more logical room for `/docs`, `/ansible` etc
- [ ] fnm postinstall. after fnm is installed, it looks for a "default" version. part of fnm installation should set this up to the latest lts
- [ ] to gnome-keyring install, add a step that modifies PAM

```
# /etc/pam.d/login (for tty)
auth       optional     pam_gnome_keyring.so
session    optional     pam_gnome_keyring.so auto_start
```

```

# /etc/pam.d/ly (for ly)
auth       optional     pam_gnome_keyring.so
session    optional     pam_gnome_keyring.so auto_start
```

- [ ] gnome-keyring alternative that works with cli and script setup? how do other people do it? has to work with 1pass
- [ ] add sshd.d stuff
- [ ] read more about and correctly modify ssh_config "control" section

