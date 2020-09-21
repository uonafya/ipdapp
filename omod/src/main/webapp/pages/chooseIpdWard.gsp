<%
	ui.decorateWith("appui", "standardEmrPage", [title: "IPD Ward"])
	ui.includeJavascript("ehrconfigs", "jquery-1.12.4.min.js")
	ui.includeJavascript("ehrconfigs", "jquery-ui-1.9.2.custom.min.js")
	ui.includeJavascript("ehrconfigs", "underscore-min.js")
	ui.includeJavascript("ehrconfigs", "knockout-3.4.0.js")
	ui.includeJavascript("ehrconfigs", "emr.js")
	ui.includeCss("ehrconfigs", "jquery-ui-1.9.2.custom.min.css")
	// toastmessage plugin: https://github.com/akquinet/jquery-toastmessage-plugin/wiki
	ui.includeJavascript("ehrconfigs", "jquery.toastmessage.js")
	ui.includeCss("ehrconfigs", "jquery.toastmessage.css")
	// simplemodal plugin: http://www.ericmmartin.com/projects/simplemodal/
	ui.includeJavascript("ehrconfigs", "jquery.simplemodal.1.4.4.min.js")
	ui.includeCss("ehrconfigs", "referenceapplication.css")
%>
<style>
	ul.select.wards li {
		border: 1px solid #efefef;
		margin: 0 1px 4px 0;
		width: 18.4%;
	}
	ul.select.wards li.selected{
		background-color: #007FFF; 
		color: #fff!important;
		border-color: transparent
	}
	ul.select.wards li:hover a {
		color: #fff;
		text-decoration: none;
	}
	ul.select.wards li:hover .desc {
		color: #fff;		
		-moz-transition:color .3s ease-in;
		-o-transition:color .3s ease-in;
		-webkit-transition:color .3s ease-in;
		transition:color .3s ease-in;
	}	
	ul.select.wards li .desc{
		border-top: 1px solid #efefef;
		color: #f26522;
		padding-top: 4px;
		text-align: center;
		font-family: "OpenSansBold",Arial,sans-serif;
	}
	.ward-summary{
		display: inline-block;
		color: #444;
	}
	.ward-summary i{
		color: #444;
	}
	.ui-widget-content a {
		color: #007fff;
	}
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	.new-patient-header .identifiers {
		margin-right: -5px;
		margin-top: 10px;
	}
	.name {
		color: #f26522;
	}
	.new-patient-header .identifiers span {
		border-radius: 5px;
	}
</style>


<div class="patient-header new-patient-header">
	<div class="demographics">
		<h1 class="name" style="border-bottom: 1px solid #ddd;">
			<span>INPATIENT WARDS &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
		</h1>
	</div>

	<div class="identifiers">
		<em>&nbsp; &nbsp; Count:</em>
		<span>${wardOverviewList.size()} wards available</span>
	</div>
</div>

<ul class="select wards">
    <% wardOverviewList.each { it -> %>
		<li>
			<a href='${ui.pageLink("ipdapp", "patientsAdmission", [ipdWard: it.wardConcept.id ])}'>
				<div style="display: inline-block">
					<i class="icon-hospital" style="width: auto;"></i>					
				</div>
				
				<div class="ward-summary">
					<i class="icon-bed small"></i>${it.bedCount} Beds</span><br/>
					<i class="icon-user small"></i>${it.patientCount} Patients				
				</div>
				<div class="desc">${it.wardConcept.name}</div>
			</a>
		</li>
    <% } %>
</ul>






