#Dashing API

## Building

Build a gem:
```sh
gem build dashing-api.gemspec
```

Install:
```sh
gem install dashing-api-<version>.gem
```

## API endpoints

List the existing widgets:
```sh
curl http://<hostname>/widgets/
```

List the existing dashboards:
```sh
curl http://<hostname>/dashboards/
```

Check if a dashboard exists:
```sh
curl http://<hostname>/dashboards/:id
```

Get the current status of a host:
```sh
curl -i -H "Accept: application/json" http://<hostname>/tiles/:id.json
```

Check if a nagios host has a job script:
```sh
curl -i http://<hostname>/tiles/:id
```

Check if a nagios host exists on a dashboard:
```sh
curl -i http://<hostname>/tiles/:dashboard/:hosts
```

Delete a dashboard:
```sh
curl -X DELETE -H "Content-type: application/json" -d '{"auth_token": "YOUR_AUTH_TOKEN", "dashboard": ""}' http://<hostname>/dashboards/
```

Rename a dashboard:
```sh
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "YOUR_AUTH_TOKEN", "from": "", "to": ""}' http://<hostname>/dashboards/
```

Replace a nagios host on a dashboard:
```sh
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "YOUR_AUTH_TOKEN", "dashboard": "", "from": "", "to": ""}' http://<hostname>/tiles/
```

Create a dashboard
```sh
curl -i -H 'Accept: application/json' -d '{"auth_token": "YOUR_AUTH_TOKEN", "dashboard": , "tiles": {"hosts": [" "," "], "titles": [" ", " "], "widgets": [" ", " "], "urls": [" ", " "]}}' http://<hostname>/dashboards/
```

