require 'erb'
require 'socket'
  
def getTemplate()
   %{
    	<script type='text/javascript'>
      	$(function myFunction() {
        	$('li').live('click', function(e) { 
        	var widget = $(this).find('widget');
            var url = widget.data('url');
            window.open(url, '_blank', "width=900, height=900, scrollvars=yes, toolbar=yes, resizable=yes");
        	});
    	});
      	</script>

      	<div class="gridster">
        	<ul>
         	<% for i in 0..body["tiles"]["hosts"].length-1 %>
            <li data-row="1" data-col="1" data-sizex="2" data-sizey="2" onClick="myFunction()">
               <div data-id="<%= body["tiles"]["hosts"][i] %>" data-view="<%= body["tiles"]["widgets"][i]  %>" data-unordered="true" data-title="<%= body["tiles"]["titles"][i] %>" data-url="<%= body["tiles"]["urls"][i]  %>" data-bind-style="status" style="style"></div>
            </li>
         	<% end %>
         	</ul>
      	</div>
   }
end


class HelperFunctions

    include ERB::Util

    def initialize
    	@template = getTemplate
    end

    # Check if the auth_token is a valid 
    def checkAuthToken(body, token)
    	auth_token = body["auth_token"]
    	if token == auth_token
       	    return true
    	else
       	    return false
    	end
    end

    # Check if a nagios host/hosts exists on a dashboard
    def tileExists(dashboard, hosts, directory)
    	if hosts.kind_of?(Array)
       	    arrHosts = hosts
    	else
       	    arrHosts = hosts.split(",")
    	end

	doNotExist = Array.new
    	for hosts in arrHosts
    	    host = "data-id=\""+hosts+"\""
       	    if File.foreach(directory+'/dashboards/'+dashboardName+'.erb').any?{ |l| l[host]  }
                next
       	    else 
          	doNotExist.push(hosts)
       	    end
    	end
    	return doNotExist
    end

    # Check if the dashboard exists within the dashboard folder
    def dashboardExists(dashboardName, directory)
    	if File.exist?(directory+'/dashboards/'+dashboardName+'.erb')
       	    return true
    	else
       	    return false
    	end
    end

    def render(body)
        ERB.new(@template).result(binding)
    end

    def save(file, body)
    	File.new(file, "w")
     	File.open(file, "w+") do |f|
            f.write(render(body))
     	end
    end

    def checkArray(body)
        hostLen = body["tiles"]["hosts"].length
     	widgetLen = body["tiles"]["widgets"].length
     	titleLen = body["tiles"]["titles"].length
     	
     	if hostLen.equal?(widgetLen) and widgetLen.equal?(titleLen)
     	    return true
     	else
     	    return false
     	end
    end
     	
    def createDashboard(body, dashboardName, directory)
        dashboard = directory+'/dashboards/'+dashboardName+'.erb'
        if checkArray(body) 
    	    save(dashboard, body)
    	    return true
    	else
    	    return false
    	end
    end
  
     def deleteTile(dashboard, hosts)
     	return hosts
     end

  	# Get the hostname
    def getHost()
        return Socket.gethostname
    end
end

