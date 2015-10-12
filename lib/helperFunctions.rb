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
         <% body["Nagios"]["hosts"].zip(body["Nagios"]["title"]) do |host, title| %>
            <li data-row="1" data-col="1" data-sizex="2" data-sizey="2" onClick="myFunction()">
               <div data-id="<%=host%>" data-view="Nagios" data-unordered="true" data-title="<%=title%>" data-url="http://<%=host%>.osb.ft.com/nagios/cgi-bin/status.cgi" data-bind-style="status" style="style"></div>
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
    @auth_token = body["auth_token"]
    if token == @auth_token
       return true
    else
       return false
    end
  end

  # Check if a nagios host/hosts exists on a dashboard
  def nagiosHostExists(dashboard, hosts)
    if hosts.kind_of?(Array)
       arrHosts = hosts
    else
       arrHosts = hosts.split(",")
    end

    dontExist = Array.new
    for hosts in arrHosts
       if File.foreach("/apps/dashing/dashboards/"+dashboard+".erb").any?{ |l| l[hosts]  }
          next
       else 
          dontExist.push(hosts)
       end
    end
    return dontExist
  end

  # Check if the dashboard exists within the dashboard folder
  def dashboardExists(dashboardName)
    @dashboardName = dashboardName
    if File.exist?('/apps/dashing/dashboards/'+@dashboardName+'.erb')
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

  def createDashboard(body, dashboardName)
    @body = body
    @dashboard = '/apps/dashing/dashboards/'+dashboardName+'.erb'
    save(@dashboard, @body)
    return @body
  end
  
  def deleteTile(dashboard, hosts)
    return hosts
  end

  # Get the hostname
  def getHost()
     return Socket.gethostname
  end
end

