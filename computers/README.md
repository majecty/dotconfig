# Computer configs

We are using cron and systemd to run repeated tasks automatically. We
are planning to migrate cron jobs to systemd.

## systemd

To install the systemd scripts, follow the commands below.

```sh
ln -srb computers/home/systemd/auto-backup-org-roam.service ~/.config/systemd/user/
ln -srb computers/home/systemd/auto-backup-org-roam.timer ~/.config/systemd/user/
ln -srb computers/home/systemd/auto-backup-dotconfig.service ~/.config/systemd/user/
ln -srb computers/home/systemd/auto-backup-dotconfig.timer ~/.config/systemd/user/

systemctl --user enable auto-backup-org-roam
systemctl --user enable auto-backup-org-roam.timer
systemctl --user enable auto-backup-dotconfig
systemctl --user enable auto-backup-dotconfig.timer
```
