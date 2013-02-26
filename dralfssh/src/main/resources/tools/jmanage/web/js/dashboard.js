/*
 * Copyright 2004-2005 jManage.org
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

	function refreshDBComponent(dashboardId, component, timeout, appId, varName, varValue){
		var varURL = '/app/drawDashboardComponent.do?applicationId=' + appId + '&dashBID=' + dashboardId + '&componentID=' + component + '&' + varName + '=' + varValue;
		//alert(varURL);
		dojo.io.bind({
			url: varURL,
	    	load: function(type, data, evt){
				var divElement = document.getElementById(component);
				//alert(data);
        		divElement.innerHTML = data;		           
	    	  },
	    	method: "POST",
	    	mimetype: "text/plain"
		});
	
		if(timeout > 0){	
			// we need to auto refresh, only if timeout has a value greater than zero
			funcName = "refreshDBComponent('" + dashboardId + "','" + component + "', " + timeout + ",'" + appId + "','" + varName + "','" + varValue + "')";
			//alert(funcName);
			self.setTimeout(funcName, timeout);
		}
	}

	var eventHandlers = new Array();
	
	// custom object
	function eventHandler(component, eventName, targetComponent, dataVar, applicationId){
		this.component = component;
		this.eventName = eventName;
		this.targetComponent = targetComponent;
		this.dataVar = dataVar;
		this.applicationId = applicationId;
	}

	function addEventHandler(component, eventName, targetComponent, dataVar, applicationId){
		var handlerObj = new eventHandler(component, eventName, targetComponent, dataVar, applicationId);
		eventHandlers.push(handlerObj);	
	}

	function handleEvent(dashboardId, component, eventName, data){
		for(i=0; i<eventHandlers.length; i++){
			if(eventHandlers[i].component == component && eventHandlers[i].eventName == eventName){
				refreshDBComponent(dashboardId, eventHandlers[i].targetComponent, 0, eventHandlers[i].applicationId, eventHandlers[i].dataVar, data);
			} 	
		}	
	}




