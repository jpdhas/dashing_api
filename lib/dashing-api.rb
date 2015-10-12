require 'helperFunctions'

functions = HelperFunctions.new

#Dashing endpoint to get the list of dashboards
get '/dashboard/list' do
  content_type :json
  result = %x`ls dashboards/`
  return result
end

# Dashing endpoint to get the current data of a tile
get '/widgets/:id.json' do
  content_type :json
  if data = settings.history[params[:id]]
     data.split[1]
  end
end  

# Check if a nagios host has a job script
get '/hosts/:id' do
   content_type :json
   hostName = params[:id]
   if settings.history[hostName]
      "Nagios host has a job script"
      { :host => hostName, :status => '200 OK' }.to_json
   else
      { :host => hostName, :status => '404 Not Found' }.to_json
   end
end

# Get a list of all existing widgets
get '/widgets/' do
  content_type :json
  %x`ls widgets/`
end


# Get a list of a existing dashboards
get '/dashboards/' do
  content_type :json
  output = %x`ls dashboards/*.erb | xargs -n1 basename`
  output.reverse
  output.split('/n')
end


# Check if a dashboard exists
get '/dashboards/:id' do
  dashboard = params[:id]    
  if functions.dashboardExists(dashboardName)
     { :dashboard => dashboard, :status => '200 OK' }.to_json
  else
     { :dashboard => dashboard, :status => '404 Not Found' }.to_json
  end
end


# Check if a nagios host/hosts exists on a dashboard
get '/hosts/:dashboard/:hosts'  do

  hosts = params[:hosts]
  dashboard = params[:dashboard]
  if functions.dashboardExists(dashboard)
     output = functions.nagiosHostExists(dashboard, hosts)
  
     if output.empty?
        "Hosts "+hosts+" are on the dashboard!"
     else
        "Hosts "+output.join(',')+" are not on the dashboard"
     end

  else
     "Dashboard "+dashboard+ " does not exist!"
  end
end


# Rename a dashboard
put '/dashboards/' do
  request.body.rewind
  body = JSON.parse(request.body.read)
  
  if functions.checkAuthToken(body, settings.auth_token)
    if functions.dashboardExists(body["from"])
       File.rename("/apps/dashing/dashboards/"+body["from"]+".erb", "/apps/dashing/dashboards/"+body["to"]+".erb")
       "Dashboard renamed!"
    else
      "Dashboard "+body["from"]+" does not exist!"
    end
  else 
    "Invalid API Key!" 
  end
end

# Replace a nagios host on a dashboard
put '/widgets/' do
  request.body.rewind
  body = JSON.parse(request.body.read)
  dashboard = body["dashboard"]
  from = body["from"]
  to = body["to"]

  if functions.checkAuthToken(body, settings.auth_token)
     if dashboard != "blue"
        if functions.dashboardExists(dashboard)
           output = functions.nagiosHostExists(dashboard,from)
           if output.empty?
              File.write("/apps/dashing/dashboards/"+dashboard+".erb",File.open("/apps/dashing/dashboards/"+dashboard+".erb",&:read).gsub(from,to))
              "Nagios host renamed"
           else
              "The host is not on the dashboard. Make sure you have given the correct host name"
           end
        else
           "Dashboard "+dashboard+" does not exist!"
        end
     else
        "Permission denied to modify the Ops dashboard!"
     end
  else
     "Invalid API Key!"
  end

end

# Create a new dashboard
post '/dashboards/' do
  request.body.rewind
  body = JSON.parse(request.body.read)
  dashboard = body["dashboard"]

  if functions.checkAuthToken(body, settings.auth_token)
    if !functions.dashboardExists(dashboard)
       functions.createDashboard(body, dashboard) 
       "Dashboard created! Link to your new dashboard: http://"+dashingHost+"/"+dashboard
    else
       "Dashboard already exists!"
    end
  else
    "Invalid API Key!"
  end
end


# Delete the dashboard
delete '/dashboards/' do
  request.body.rewind
  body = JSON.parse(request.body.read)
  dashboard = body["dashboard"]
 
  if functions.checkAuthToken(body, settings.auth_token)
     if dashboard != "blue"
         if functions.dashboardExists(dashboard)
            File.delete("/apps/dashing/dashboards/"+dashboard+".erb")
            "Dashboard "+dashboard+" deleted!"
         else
            "Dashboard "+dashboard+" does not exist!"
         end
     else
        "Permission denied to delete the Ops dashboard"
     end
  else
     "Invalid API Key!"
  end
end


# Delete a tile
delete '/widgets/' do
  request.body.rewind
  body = JSON.parse(request.body.read)
  dashboard = body["dashboard"]
  hosts = body["hosts"]

  if functions.checkAuthToken(body, settings.auth_token)
     if dashboard != "blue"
        if functions.dashboardExists(dashboard)
           if output.empty?
              functions.deleteTile(dashboard, hosts)
           else
              "Hosts "+output.join(',')+" are not on the dashboard"
           end
        else
           "Dashboard "+dashboard+" does not exist!"
        end
     else
        "Cant modify the Ops dashboard"
     end
  else
     "Invalid API Key!"
  end
end

