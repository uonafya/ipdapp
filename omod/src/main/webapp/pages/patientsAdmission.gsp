<%
    ui.decorateWith("appui", "standardEmrPage", [title: "IPD Ward"])
	ui.includeJavascript("billingui", "moment.js")
	
	ui.includeCss("uicommons", "datatables/dataTables_jui.css")
    ui.includeJavascript("patientqueueapp", "jquery.dataTables.min.js")
%>
    
<script>
	var refreshInTable = function(resultData, dTable){
		var rowCount = resultData.length;
		if(rowCount == 0){
			dTable.find('td.dataTables_empty').html("No Records Found");
		}
		dTable.fnPageChange(0);
	};
	
	var isTableEmpty = function(resultData, dTable){
		if(resultData.length > 0){
			return false
		}
		return !dTable || dTable.fnGetNodes().length == 0;
	};
	
	jq(function () {
		jq("#tabs").tabs();
		
		jq('li.ui-corner-top a').click(function(){
			if (jq(this).attr('href') == '#ipd-patients'){
				jq('#refresher a').html('<i class="icon-refresh"></i>Refresh Patients');
				getAdmittedPatients();
			}
			else{
				jq('#refresher a').html('<i class="icon-refresh"></i>Refresh Queue');
				getAdmissionQueue();
			}
		});
		
		jq('#refresher a').click(function(){
			if (jq('li.ui-state-active').attr('aria-controls') == "ipd-patients"){
				getAdmittedPatients();
			}
			else if (jq('li.ui-state-active').attr('aria-controls') == "ipd-queue"){
				getAdmissionQueue();
			}
		});
	});
</script>

<style>
	.toast-item {
        background-color: #222;
    }
	.paginate_disabled_previous, .paginate_enabled_previous, .paginate_disabled_next, .paginate_enabled_next{
		width:auto;
	}
	.button.task, button.task, input[type="submit"].task, input[type="button"].task, input[type="submit"].task, a.button.task{
		min-width: auto;
	}
	.dataTables_length{
		text-align: left
	}	
	.dropdown ul {
		z-index: 9;
	}
	.dropdown ul li {
		width: 200px;
	}
	.ui-tabs .ui-tabs-panel {
		padding: 2px;
	}
	#queueList td:nth-child(6){
		padding: 5px 0;
	}
	#admittedList td:nth-child(6){
		padding: 5px 2px;
	}
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	.name {
		color: #f26522;
	}
	.new-patient-header .identifiers {
		margin: 10px 0 0;
	}
	#tabs {
		background: #f9f9f9 none repeat scroll 0 0;
		margin-top: 10px;
	}
	#refresher {
		border: 1px none #88af28;
		color: #fff !important;
		float: right;
		margin-top: 5px;
	}
</style>

<div class="example">
	<ul id="breadcrumbs">
		<li>
			<a href="${ui.pageLink('referenceapplication','home')}">
				<i class="icon-home small"></i></a>
		</li>
		
		<li>
			<i class="icon-chevron-right link"></i>
			<a href="chooseIpdWard.page">IPD Wards</a>
		</li>
		
		<li>
			<i class="icon-chevron-right link"></i>
			${ipdWard.name}
		</li>
	</ul>
</div>

<div class="patient-header new-patient-header">
	<div class="demographics">
		<h1 class="name" style="border-bottom: 1px solid #ddd;">
			<span>${ipdWard.name} &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
		</h1>
	</div>

	<div class="identifiers">
		<em>&nbsp; &nbsp; Patients:</em>
		<span>${listPatientAdmitted.size()} admitted, ${listPatientAdmission.size()} waiting</span>
	</div>
	
	<div class="clear"></div>
	
	<div id="tabs">
		<ul>
			<li><a href="#ipd-patients">Admitted</a></li>
			<li><a href="#ipd-queue">Admission Queue</a></li>
			<li id="refresher" class="ui-state-default">
				<a class="button confirm" style="color:#fff">
					<i class="icon-refresh"></i>
					Refresh Patients
				</a>
			</li>
		</ul>

		<div id="ipd-patients">
			${ui.includeFragment("ipdapp", "admittedPatients")}
		</div>
		
		<div id="ipd-queue">      
			${ui.includeFragment("ipdapp", "admissionQueue")}
		</div>
	</div>
</div>





