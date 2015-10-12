List the existing widgets:
curl "http://<hostname>/widgets/"

List the existing dashboards:
curl "http://<hostname>/dashboards/"

Check if a dashboard exists:
curl -i "http://<hostname>/dashboards/:id"

Get the current status of a host:
curl -i -H "Accept: application/json" "http://<hostname>/hosts/:id.json"

Check if a nagios host has a job script:
curl -i "http://<hostname>/hosts/:id"

Check if a nagios host exists on a dashboard:
curl -i "http://<hostname>/hosts/:dashboard/:hosts"

Delete a dashboard:
curl -X DELETE -H "Content-type: application/json" -d '{"auth_token": "YOUR_AUTH_TOKEN", "dashboard": ""}' "http://<hostname>/dashboards/"

Rename a dashboard:
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "YOUR_AUTH_TOKEN", "from": "", "to": ""}' "http://<hostname>/dashboards/"

Replace a nagios host on a dashboard:
curl -i -H 'Accept: application/json' -X PUT -d '{"auth_token": "YOUR_AUTH_TOKEN", "dashboard": "", "from": "", "to": ""}' "http://<hostname>/widgets/"

Create a dashboard
curl -i -H 'Accept: application/json' -d '{"auth_token": "YOUR_AUTH_TOKEN", "dashboard": , "Nagios": {"hosts": [" "," "], "title": [" ", " "]}}' http://<hostname>/dashboards/
