require 'json'
require 'helperFunctions'

  functions = HelperFunctions.new

  # Get the current status of a tile
  get '/tiles/:id.json' do
    content_type :json
    if data = settings.history[params[:id]]
       data.split[1]
    end
  end  

  # Check if a nagios host has a job script
  get '/tiles/:id' do
     content_type :json
     hostName = params[:id]
     if settings.history[hostName]
        { :host => hostName, :message => 'Nagios host has a job script' }.to_json
     else
	status 404
        { :host => hostName, :message => 'Nagios host does not have a job script' }.to_json
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
    if functions.dashboardExists(dashboard)
       { :dashboard => dashboard, :message => 'Dashboard exists' }.to_json
    else
	status 404
       { :dashboard => dashboard, :message => 'Dashboard does not exist' }.to_json
    end
  end


  # Check if a nagios host/hosts exists on a dashboard
  get '/tiles/:dashboard/:hosts'  do

    hosts = params[:hosts]
    dashboard = params[:dashboard]
    if functions.dashboardExists(dashboard)
       output = functions.nagiosHostExists(dashboard, hosts)
    
       if output.empty?
          { :dashboard => dashboard, :hosts => hosts, :message => 'Hosts exists on the dashboard' }.to_json
       else
	status 400
          { :dashboard => dashboard, :hosts => output.join(','), :message => 'Hosts are not on the dashboard' }.to_json
       end
    else
	status 404
       { :dashboard => dashboard, :message => 'Dashboard does not exist' }.to_json
    end
  end


  # Rename a dashboard
  put '/dashboards/' do
    request.body.rewind
    body = JSON.parse(request.body.read)
    
    if functions.checkAuthToken(body, settings.auth_token)
      if functions.dashboardExists(body["from"])
         File.rename("/apps/dashing/dashboards/"+body["from"]+".erb", "/apps/dashing/dashboards/"+body["to"]+".erb")
         { :message => 'Dashboard Renamed' }.to_json
      else
	status 400
        { :dashboard => body["from"], :message => 'Dashboard does not exist'}.to_json
      end
    else 
	status 403
      { :message => 'Invalid API Key' }.to_json
    end
  end

  # Replace a nagios host on a dashboard
  put '/tiles/' do
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
                { :message => 'Nagios host renamed' }.to_json
             else
		status 400
                { :dashboard => dashboard, :host => from, :message => 'Host not on the dashboard. Make sure you have given the correct hostname' }.to_json
             end
          else
		status  400
             { :dashboard => dashboard, :message => 'Dashboard does not exist' }.to_json
          end
       else
	  status 403
          { :message => 'Cannot modify the main dashboard' }.to_json
       end
    else
	status 403
       { :message => 'Invalid API Key'}.to_json
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
         dashboardLink = "http://"+functions.getHost()+"/"+dashboard
         { :message => 'Dashboard Created', :dashboardLink => dashboardLink }.to_json
      else
	 status 400
         { :message => 'Dashboard already exists' }.to_json
      end
    else
	status 403
      { :message => 'Invalid API Key' }.to_json
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
              { :message => 'Dashboard deleted' }.to_json
           else
		status 400
              { :message => 'Dashboard does not exist' }.to_json
           end
       else
	  status 403
          { :message => 'Cannot delete the Ops dashboard' }.to_json
       end
    else
	status 403
       { :message => 'Invalid API Key' }.to_json
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
