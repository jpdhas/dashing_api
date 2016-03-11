require 'erb'
require 'socket'
require 'nokogiri'
require 'open-uri'
require 'net/ping'
  
def newDashboardTemplate()
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

def addDeleteTileTemplate()
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
                <% for i in 0..body.length-1%>
                        <%= body[i] %>
                <% end %>
                </ul>
        </div>
   }
end

class HelperFunctions

    include ERB::Util

    def initialize
    	@newDashboardTemplate = newDashboardTemplate
    	@addDeleteTileTemplate = addDeleteTileTemplate
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
       	    if File.foreach(directory+'/dashboards/'+dashboard+'.erb').any?{ |l| l[host]  }
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

    def render(body, template)
        ERB.new(template).result(binding)
    end

    def save(file, body, template)
    	File.new(file, "w")
     	File.open(file, "w+") do |f|
            f.write(render(body, template))
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
     	
    def createDashboard(body, dashboard, directory)
        dashboard = directory+'/dashboards/'+dashboard+'.erb'
        if checkArray(body) 
    	    save(dashboard, body, @newDashboardTemplate)
    	    return true
    	else
    	    return false
    	end
    end
  
    def getHtmlElements(dashboard, hosts)
        liElements = Array.new
        finalElement = Array.new
        doc = Nokogiri::HTML(open(dashboard))
        liElements = doc.search('div > ul > li')

        liElements.each do |item|
            element = item.to_s
            if hosts.any? { |w| element[w] }
                next
            else
                finalElement.push(element)
            end
        end
        return finalElement
    end
  
    def deleteTile(dashboard, hosts, directory)
        liElements = Array.new
        finalElement = Array.new
        dashboard = directory+'/dashboards/'+dashboard+'.erb'

        doc = Nokogiri::HTML(open(dashboard))
        liElements = doc.search('div > ul > li')

        liElements.each do |item|
            element = item.to_s
            if hosts.any? { |w| element[w] }
                next
            else
                finalElement.push(element)
            end
        end
        save(dashboard, finalElement, @addDeleteTileTemplate)
    end
    
    def addTile(dashboard, body, directory)
        dashboard = directory+'/dashboards/'+dashboard+'.erb'
        finalElement = Array.new
        if checkArray(body)
            finalElement = getHtmlElements(dashboard, body['tiles']['hosts'])

            for i in 0..body["tiles"]["hosts"].length-1
                host = body["tiles"]["hosts"][i]
                widget = body["tiles"]["widgets"][i]
                title = body["tiles"]["titles"][i]
                url = body["tiles"]["urls"][i]

                tileElement = ["<li data-row=\"1\"  data-col=\"1\" data-sizex=\"2\" data-sizey=\"2\" onClick=\"myFunction()\">
                                <div data-id=\"", host,"\" data-view=\"", widget,"\" data-unordered=\"true\" data-title=\"", title,"\" data-url=\"", url, "\" data-bind-style=\"status\" style=\"style\"></div>
                               </li>"  ].join
                finalElement.push(tileElement)
            end
            save(dashboard, finalElement, @addDeleteTileTemplate)
            return true
        else
            return false
        end
    end

    def up?(host)
        check = Net::Ping::External.new(host)
        return check.ping?
    end


    def uniq?(array)
        if array.length == array.uniq.length
            return true
        else
            return false
        end
    end

    def pingHosts(dashboard, body, directory)
        notFound = Array.new

        upArr = Array.new
        downArr = Array.new

        if uniq?(body["tiles"]["hosts"])
            body["tiles"]["hosts"].each do |host|
                if up?(host)
                    upArr.push(host)
                else
                    downArr.push(host)
                end
            end

            upOutput = tileExists(dashboard, upArr, directory)

            if !upOutput.empty?
                hosts = Array.new
                titles = Array.new
                widgets = Array.new
                urls = Array.new

                for i in 0..upOutput.length-1
                    host = upOutput[i]
                    for j in 0..body["tiles"]["hosts"].length-1
                            checkhost = body["tiles"]["hosts"][j]
                            if checkhost == host
                                hosts.push(host)
                                widgets.push(body["tiles"]["widgets"][j])
                                titles.push(body["tiles"]["titles"][j])
                                urls.push(body["tiles"]["urls"][j])
                            else
                                next
                            end
                    end
                end

                jsonArray = { :tiles => { :hosts => hosts, :widgets => widgets, :titles => titles, :urls => urls} }.to_json
                objArray = JSON.parse(jsonArray)

                addTile(dashboard, objArray, directory)
            end

            downOutput = tileExists(dashboard, downArr, directory)

            if !downOutput.empty?
                tileToRemove = downArr - downOutput
            else
                tileToRemove = downArr
            end

            deleteTile(dashboard, tileToRemove, directory)
            return true
        else
            return false
        end
    end


    # Get the hostname
    def getHost()
        return Socket.gethostname
    end
end

