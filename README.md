#Dashing API

## Building

Build a gem:
```sh
rake build
```

Install:
```sh
rake install
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

Get the current status of a tile:
```sh
curl -i -H "Accept: application/json" http://$DASHING_HOST/tiles/:id.json
```

Check if a job script exist for data-id:
```sh
curl -i http://$DASHING_HOST/jobs/:id
```

Check if a tile exists on a dashboard:
```sh
curl -i http://$DASHING_HOST/tiles/:dashboard/:hosts
```

Delete a dashboard:
```sh
curl -X DELETE -H "Content-type: application/json" -d '{"auth_token": "$DASHING_AUTH_TOKEN"}' http://$DASHING_HOST/dashboards/:dashboard
```

Rename a dashboard:
```sh
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "$DASHING_AUTH_TOKEN", "from": "", "to": ""}' http://$DASHING_HOST/dashboards/
```

Replace a tile on a dashboard:
```sh
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "$DASHING_AUTH_TOKEN", "dashboard": "", "from": "", "to": ""}' http://$DASHING_HOST/tiles/
```

Create a dashboard
```sh
curl -i -H 'Accept: application/json' -X POST -d '{"auth_token": "$DASHING_AUTH_TOKEN", "tiles": {"hosts": [" "," "], "titles": [" ", " "], "widgets": [" ", " "], "urls": [" ", " "]}}' http://$DASHING_HOST/dashboards/:dashboard
```

Delete a tile/ tiles from a dashboard:
```sh
curl -i -H 'Accept: application/json' -X DELETE -d '{"auth_token": "$DASHING_AUTH_TOKEN", "tiles": [" ", " "]}' http://$DASHING_HOST/tiles/:dashboard
```

Add a tile/tiles to a dashboard
```sh
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "$DASHING_AUTH_TOKEN", "tiles": {"hosts": [" "," "], "titles": [" ", " "], "widgets": [" ", " "], "urls": [" ", " "]}}' http://$DASHING_HOST/tiles/:dashboard
```

Ping hosts and add to/ remove tiles from a dashboard
```sh
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "$DASHING_AUTH_TOKEN", "tiles": {"hosts": [" "," "], "titles": [" ", " "], "widgets": [" ", " "], "urls": [" ", " "]}}' http://$DASHING_HOST/ping/:dashboard
```

## Use the gem with dashing

* Add `'gem dashing-api'` to the `Gemfile`
* Require the gem in `config.ru` by adding `require 'dashing-api'`
* Run `bundle install` from the project's directory
* Restart dashing
