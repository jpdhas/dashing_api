#Dashing API

## Building

Build a gem:
```sh
gem build dashing-api.gemspec
```

Install:
```sh
gem install dashing-api-$VERSION.gem
```

## API endpoints

List the existing widgets:
```sh
curl http://$DASHING_HOST/widgets/
```

List the existing dashboards:
```sh
curl http://$DASHING_HOST/dashboards/
```

Check if a dashboard exists:
```sh
curl http://$DASHING_HOST/dashboards/:id
```

Get the current status of a host:
```sh
curl -i -H "Accept: application/json" http://$DASHING_HOST/tiles/:id.json
```

Check if a nagios host has a job script:
```sh
curl -i http://$DASHING_HOST/tiles/:id
```

Check if a nagios host exists on a dashboard:
```sh
curl -i http://$DASHING_HOST/tiles/:dashboard/:hosts
```

Delete a dashboard:
```sh
curl -X DELETE -H "Content-type: application/json" -d '{"auth_token": "$DASHING_AUTH_TOKEN", "dashboard": ""}' http://$DASHING_HOST/dashboards/
```

Rename a dashboard:
```sh
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "$DASHING_AUTH_TOKEN", "from": "", "to": ""}' http://$DASHING_HOST/dashboards/
```

Replace a nagios host on a dashboard:
```sh
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "$DASHING_AUTH_TOKEN", "dashboard": "", "from": "", "to": ""}' http://$DASHING_HOST/tiles/
```

Create a dashboard
```sh
curl -i -H 'Accept: application/json' -X POST -d '{"auth_token": "$DASHING_AUTH_TOKEN", "dashboard": "", "tiles": {"hosts": [" "," "], "titles": [" ", " "], "widgets": [" ", " "], "urls": [" ", " "]}}' http://$DASHING_HOST/dashboards/
```

Delete a tile/ tiles from a dashboard:
```sh
curl -i -H 'Accept: application/json' -X DELETE -d '{"auth_token": "$DASHING_AUTH_TOKEN", "dashboard": "", "tiles": [" ", " "]}' http://$DASHING_HOST/tiles/
```

Add a tile/tiles to a dashboard
```sh
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "$DASHING_AUTH_TOKEN", "dashboard": "", "tiles": {"hosts": [" "," "], "titles": [" ", " "], "widgets": [" ", " "], "urls": [" ", " "]}}' http://$DASHING_HOST/tiles/:dashboard
```

Ping hosts and add to/ remove from a dashboard
```sh
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "$DASHING_AUTH_TOKEN", "dashboard": "", "tiles": {"hosts": [" "," "], "titles": [" ", " "], "widgets": [" ", " "], "urls": [" ", " "]}}' http://$DASHING_HOST/ping/:dashboard
```

## Use the gem with dashing

* Add `gem dashing-api` and `gem net/ping` to the `Gemfile`
* Require the gem in `config.ru` by adding `require 'dashing-api'`
* Run `bundle` from the project's directory
* Restart dashing
