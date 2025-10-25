# Setup

```sh
sudo chmod +x /usr/local/bin/update_maintenance_html.sh
```

sudo vim /etc/systemd/system/update-maintenance.service
```sh
[Unit]
Description=Auto update maintenance HTML via curl and start nginx
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/update_maintenance_html.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```

Active
```sh
sudo systemctl daemon-reload
sudo systemctl enable update-maintenance.service
```

Test
```sh
sudo /usr/local/bin/update_maintenance_html.sh
```
