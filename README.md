# Dashing API

## Test it locally

Build a gem:
```sh
rake build
```

Install:
```sh
rake install
```

## Installation

Add this line to your application's Gemfile:

  ```sh
  gem 'dashing_api'
  ```

And then execute:

  ```sh
  bundle
  ```

Or install it yourself as:

  ```sh
  gem install dashing_api
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

[MIT License](https://github.com/Financial-Times/dashing_api/blob/master/LICENSE.txt)
