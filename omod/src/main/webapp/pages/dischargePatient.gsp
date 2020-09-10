<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Discharge Patient"])
    ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js", Integer.MAX_VALUE - 1)
    ui.includeJavascript("uicommons", "navigator/validators.js", Integer.MAX_VALUE - 19)
    ui.includeJavascript("uicommons", "navigator/navigator.js", Integer.MAX_VALUE - 20)
    ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorModels.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorTemplates.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/exitHandlers.js", Integer.MAX_VALUE - 22)
%>

<script>
    var NavigatorController
    jq(function(){
        NavigatorController = new KeyboardController();
    });

    jq(function() {
        //autocomplete for the discharge tab
        jq("#procedure").autocomplete({
            source: function( request, response ) {
                jq.getJSON('${ ui.actionLink("ipdapp", "PatientInfo", "getProcedures") }',{
                            q: request.term
                }).success(function(data) {
					procedureMatches = [];
					for (var i in data) {
						var result = { label: data[i].label, value: data[i].id, schedulable: data[i].schedulable };
						procedureMatches.push(result);
					}
					response(procedureMatches);
				});
            },
            minLength: 3,
            select: function( event, ui ) {
                var selectedProcedure = document.createElement('option');
                selectedProcedure.value = ui.item.value;
                selectedProcedure.text = ui.item.label;
                selectedProcedure.id = ui.item.value;
                var selectedProcedureList = document.getElementById("selectedProcedureList");

                //adds the selected procedures to the div
                var selectedProcedureP = document.createElement("div");
                selectedProcedureP.className = "selectp";

                var selectedProcedureT = document.createTextNode(ui.item.label);
                selectedProcedureP.id = ui.item.value;
                selectedProcedureP.appendChild(selectedProcedureT);

                var btnselectedRemoveIcon = document.createElement("span");
                btnselectedRemoveIcon.className = "icon-remove selecticon";
                btnselectedRemoveIcon.id = "procedureRemoveIcon";
				
                selectedProcedureP.appendChild(btnselectedRemoveIcon);

                var selectedProcedureDiv = document.getElementById("selected-procedures");

                //check if the item already exist before appending
                var exists = false;
                for (var i = 0; i < selectedProcedureList.length; i++) {
                    if(selectedProcedureList.options[i].value==ui.item.value)
                    {
                        exists = true;
                    }
                }

                if(exists == false)
                {
                    selectedProcedureList.appendChild(selectedProcedure);
                    selectedProcedureDiv.appendChild(selectedProcedureP);
                }
				
				jq('#task-procedure').show();
				jq('#procedure-set').val('SET');
            },
            open: function() {
            },
            close: function() {
				jq(this).val('');
            }
        });
		
        jq("#selected-procedures").on("click", "#procedureRemoveIcon",function(){
            var procedureP = jq(this).parent("div");
            var procedureId = procedureP.attr("id");			
            
            jq('#selectedProcedureList').find("#" + procedureId).remove();
            procedureP.remove();
			
			if (jq('#selectedProcedureList option').size() == 0){
				jq('#task-procedure').hide();
				jq('#procedure-set').val('');
			}
        });


        //diagnoses autocomplete functionality
        jq("#diagnosis").autocomplete({
            source: function( request, response ) {
                jq.getJSON('${ ui.actionLink("ipdapp", "PatientInfo", "getDiagnosis") }',
                        {
                            q: request.term
                        }
                ).success(function(data) {
                            var results = [];
                            for (var i in data) {
                                var result = { label: data[i].name, value: data[i].id};
                                results.push(result);
                            }
                            response(results);
                        });
            },
            minLength: 3,
            select: function( event, ui ) {
                var selectedInvestigation = document.createElement('option');
                selectedInvestigation.value = ui.item.value;
                selectedInvestigation.text = ui.item.label;
                selectedInvestigation.id = ui.item.value;
                var selectedInvestigationList = document.getElementById("selectedDiagnosisList");


                //adds the selected procedures to the div
                var selectedInvestigationP = document.createElement("div");
                selectedInvestigationP.className = "selectp";

                var selectedInvestigationT = document.createTextNode(ui.item.label);
                selectedInvestigationP.id = ui.item.value;
                selectedInvestigationP.appendChild(selectedInvestigationT);



                var btnselectedRemoveIcon = document.createElement("span");
                btnselectedRemoveIcon.className = "icon-remove small selecticon";
                btnselectedRemoveIcon.id = "diagnosesRemoveIcon";




                selectedInvestigationP.appendChild(btnselectedRemoveIcon);

                var selectedInvestigationDiv = document.getElementById("selected-diagnoses");

                //check if the item already exist before appending
                var exists = false;
                for (var i = 0; i < selectedInvestigationList.length; i++) {
                    if(selectedInvestigationList.options[i].value==ui.item.value)
                    {
                        exists = true;
                    }
                }

                if(exists == false)
                {
                    selectedInvestigationList.appendChild(selectedInvestigation);
                    selectedInvestigationDiv.appendChild(selectedInvestigationP);
                }
				
				jq('#task-diagnoses').show();
				jq('#diagnoses-set').val('SET');
            },
            open: function() {
            },
            close: function() {
				jq(this).val('');
            }
        });

        jq("#selected-diagnoses").on("click", "#diagnosesRemoveIcon",function(){
            var investigationP = jq(this).parent("div");
            var investigationId = investigationP.attr("id");
			
			jq('#selectedDiagnosisList').find("#" + investigationId).remove();
            investigationP.remove();
			
			if (jq('#selectedDiagnosisList option').size() == 0){
				jq('#task-diagnoses').hide();
				jq('#diagnoses-set').val('');
			}
        });






        //dicharge patient send post information
        jq("#dischargeSubmit").click(function(event){
            var selectedDiag = new Array;
            jq("#selectedDiagnosisList option").each( function() {
                selectedDiag.push ( jq(this).val() );
            });

            //get the list of selected procedures and store them in an array
            var selectedProcedureList = new Array;

            jq("#selectedProcedureList option").each( function() {
                selectedProcedureList.push ( jq(this).val() );
            });

            var dischargeFormData = {
                'dischargeAdmittedID': jq('#dischargeAdmittedID').val(),
                'patientId': jq('#dischargePatientID').val(),
                'selectedDiagnosisList': selectedDiag,
                'selectedDischargeProcedureList': selectedProcedureList,
                'dischargeOutcomes': jq('#dischargeOutcomes').val(),
                'otherDischargeInstructions': jq('#otherDischargeInstructions').val(),
            };

            jq("#dischargeForm").submit(
                    jq.getJSON('${ ui.actionLink("ipdapp", "PatientInfo", "dischargePatient") }',dischargeFormData)
                            .success(function(data) {
                                jq().toastmessage('showNoticeToast', "Patient has been discharged");
                            })
                            .error(function(xhr, status, err) {
                                jq().toastmessage('showErrorToast', "Error:" + err);
                            })
            );

        });
    });
</script>

<style>
	.toast-item {
        background-color: #222;
    }
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	.name {
		color: #f26522;
	}
	.new-patient-header .demographics .gender-age {
		font-size: 14px;
		margin-left: -55px;
		margin-top: 12px;
	}
	.new-patient-header .demographics .gender-age span {
		border-bottom: 1px none #ddd;
	}
	.new-patient-header .identifiers {
		margin-top: 5px;
	}
	.tag {
		padding: 2px 10px;
	}
	.tad {
		background: #666 none repeat scroll 0 0;
		border-radius: 1px;
		color: white;
		display: inline;
		font-size: 0.8em;
		padding: 2px 10px;
	}
	.status-container {
		padding: 5px 10px 5px 5px;
	}
	.catg {
		color: #363463;
		margin: 25px 10px 0 0;
	}
	.persondatalabel{
		width:50%;
		border: 1px;
		float: left;
		margin-bottom: 15px;
	}
	.clearboth{
		clear: both;
	}
	.persondatalabel h3{
		display: inline;
		width: 50%;
	}
	.persondatalabel h2{
		display: inline;
		width: 50%;
	}
	.morebuttons{
		display: inline;
		float: left;
		margin-left: 20px;
	}
	.tableelement{
		width: auto;
		min-width: 10px;
	}
	.vitalstatisticselements{
		float:left;
		margin-left:10px;
		margin-bottom: 10px;
	}
	.vitalstatisticselements textarea{
		height: 23px;
		width: 183px;
	}
	form input:focus, form select:focus, form textarea:focus, form ul.select:focus, .form input:focus, .form select:focus, .form textarea:focus, .form ul.select:focus,
	.simple-form-ui section fieldset select:focus, .simple-form-ui section fieldset input:focus, .simple-form-ui section #confirmationQuestion select:focus, .simple-form-ui section #confirmationQuestion input:focus, 
	.simple-form-ui #confirmation fieldset select:focus, .simple-form-ui #confirmation fieldset input:focus, .simple-form-ui #confirmation #confirmationQuestion select:focus, 
	.simple-form-ui #confirmation #confirmationQuestion input:focus, .simple-form-ui form section fieldset select:focus, .simple-form-ui form section fieldset input:focus, 
	.simple-form-ui form section #confirmationQuestion select:focus, .simple-form-ui form section #confirmationQuestion input:focus, .simple-form-ui form #confirmation fieldset select:focus, 
	.simple-form-ui form #confirmation fieldset input:focus, .simple-form-ui form #confirmation #confirmationQuestion select:focus, .simple-form-ui form #confirmation #confirmationQuestion input:focus {
		outline: 0px none #007fff;
		box-shadow: 0 0 0 0 #888;
	}
	form {
		background: #f9f9f9 none repeat scroll 0 0;
		margin-top: 3px;
	}
	#formBreadcrumb {
		background: #fff none repeat scroll 0 0;
	}
	.simple-form-ui section, .simple-form-ui #confirmation, .simple-form-ui form section, .simple-form-ui form #confirmation {
		min-height: 250px;
		width: 74%;
	}
	.tasks {
		background: white none repeat scroll 0 0;
		border: 1px solid #cdd3d7;
		border-radius: 4px;
		box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
		color: #404040;
		font: 14px/20px "Lucida Grande",Verdana,sans-serif;
		margin: 10px 0 0 4px;
		width: 98.6%;
	}
	.tasks-header {
		background: #f0f1f2 linear-gradient(to bottom, #f5f7fd, #e6eaec) repeat scroll 0 0;
		border-bottom: 1px solid #d1d1d1;
		border-radius: 3px 3px 0 0;
		box-shadow: 0 1px rgba(255, 255, 255, 0.5) inset, 0 1px rgba(0, 0, 0, 0.03);
		color: #f26522;
		line-height: 24px;
		padding: 7px 15px;
		position: relative;
		text-shadow: 0 1px rgba(255, 255, 255, 0.7);
	}
	.tasks-title {
		color: inherit;
		font-size: 14px;
		font-weight: bold;
		line-height: inherit;
	}
	.tasks-lists {
		color: transparent;
		font: 0px/0 serif;
		height: 3px;
		margin-top: -11px;
		padding: 10px 4px;
		position: absolute;
		right: 10px;
		text-shadow: none;
		top: 50%;
		width: 19px;
	}
	.tasks-lists::before {
		background: #8c959d none repeat scroll 0 0;
		border-radius: 1px;
		box-shadow: 0 6px #8c959d, 0 -6px #8c959d;
		content: "";
		display: block;
		height: 3px;
	}
	.tasks-list {
		font: 13px/20px "Lucida Grande",Verdana,sans-serif;
	}
	.tasks-list-item {
		-moz-user-select: none;
		border-bottom: 1px solid #aaa;
		cursor: pointer;
		display: inline-block;
		line-height: 24px;
		margin-right: 20px;
		padding: 5px;
		width: 150px;
	}
	.tasks-list-cb {
		display: none;
	}
	.tasks-list-mark {
		border: 2px solid #c4cbd2;
		border-radius: 12px;
		display: inline-block;
		height: 20px;
		margin-right: 0;
		position: relative;
		vertical-align: top;
		width: 20px;
	}
	.tasks-list-mark::before {
		-moz-border-bottom-colors: none;
		-moz-border-left-colors: none;
		-moz-border-right-colors: none;
		-moz-border-top-colors: none;
		border-color: #39ca74;
		border-image: none;
		border-style: solid;
		border-width: 0 0 4px 4px;
		content: "";
		display: none;
		height: 4px;
		left: 50%;
		margin: -5px 0 0 -6px;
		position: absolute;
		top: 50%;
		transform: rotate(-45deg);
		width: 8px;
	}
	.tasks-list-cb:checked ~ .tasks-list-mark {
		border-color: #39ca74;
	}
	.tasks-list-cb:checked ~ .tasks-list-mark::before {
		display: block;
	}
	.tasks-list-desc {
		color: #555;
		font-weight: bold;
	}
	.tasks-list-cb:checked ~ .tasks-list-desc {
		color: #34bf6e;
	}
	.tasks-list input[type="radio"] {
		left: -9999px !important;
		position: absolute !important;
		top: -9999px !important;
	}
	.selectp{
		border-bottom: 1px solid darkgrey;
		margin: 7px 10px;
		padding-bottom: 3px;
		padding-left: 5px;
	}
	#investigationRemoveIcon,
	#diagnosesRemoveIcon,
	#procedureRemoveIcon {
		float: right;
		color: #f00;
		cursor: pointer;
		margin: 2px 5px 0 0;
	}
	fieldset input[type="text"],
	fieldset select {
		height: 45px
	}
	.title-label {
		color: #f26522;
		cursor: pointer;
		font-family: "OpenSansBold",Arial,sans-serif;
		font-size: 1.3em;
		padding-left: 5px;
	}
	.dialog-content ul li span{
		display: inline-block;
		width: 130px;
	}
	.dialog-content ul li input{
		width: 255px;
		padding: 5px 10px;
	}
	.dialog textarea {
		width: 255px;
	}
	.dialog select {
		display: inline-block;
		width: 255px;
	}
	.dialog select option {
		font-size: 1em;
	}	
	.dialog .dialog-content li {
		margin-bottom: 3px;
	}
	.dialog select {
		margin: 0;
		padding: 5px;
	}
	#modal-overlay {
		background: #000 none repeat scroll 0 0;
		opacity: 0.4 !important;
	}
	#summaryTable tr:nth-child(2n), #summaryTable tr:nth-child(2n+1) {
		background: rgba(0, 0, 0, 0) none repeat scroll 0 0;
	}
	#summaryTable {
		margin: -5px 0 -6px;
	}
	#summaryTable tr, #summaryTable th, #summaryTable td {
		-moz-border-bottom-colors: none;
		-moz-border-left-colors: none;
		-moz-border-right-colors: none;
		-moz-border-top-colors: none;
		border-color: #eee;
		border-image: none;
		border-style: none none solid;
		border-width: 1px;
	}
	#summaryTable td:first-child {
		vertical-align: top;
		width: 180px;
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
			<a href="patientsAdmission.page?ipdWard=${patientInformation.admittedWard}">${patientInformation.admittedWard.name}</a>
		</li>
		
		<li>
			<i class="icon-chevron-right link"></i>
			<a href="patientInfo.page?search=${patient.patientIdentifier}">${patient.familyName} ${patient.givenName}'s Info</a>
		</li>
		
		<li>
			<i class="icon-chevron-right link"></i>
			Discharge
		</li>
	</ul>
</div>

<div class="patient-header new-patient-header">
	<div class="demographics">
		<h1 class="name">
			<span id="surname">${patient.familyName},<em>surname</em></span>
			<span id="othname">${patient.givenName} ${patient.middleName?patient.middleName:''}&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>other names</em></span>
			
			<span class="gender-age">
				<span>
					<% if (patient.gender == "F") { %>
						Female
					<% } else { %>
						Male
					<% } %>
					</span>
				<span id="agename">${patient.age} years (${ui.formatDatePretty(patient.birthdate)}) </span>
				
			</span>
		</h1>
		
		<br/>
		<div id="stacont" class="status-container">
			<span class="status active"></span>
			Visit Status
		</div>
		<div class="tag">Admitted</div>
		<div class="tad">Bed 00${patientInformation.bed}</div>
	</div>

	<div class="identifiers">
		<em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
		<span>${patient.patientIdentifier}</span>
		<br>
		
		<div class="catg">
			<i class="icon-tags small" style="font-size: 16px"></i><small>Category:</small> ${patient.getAttribute(14)} 
		</div>
	</div>
	<div class="clear"></div>	
</div>

<form class="simple-form-ui" id="dischargeForm" method="post">
	<section id="charges-info2">
		<span class="title">Discharge Patient</span>
		<fieldset>
			<legend>Diagnosis</legend>
			<input type="text" style="width:98.6%; margin-left:5px;" id="diagnosis" name="diagnosis" placeholder="Enter Diagnosis" />
			
			<p style="display: none">
				<input type="hidden" id="diagnoses-set" name="diagnoses-set" />
			</p>
			
			<div class="tasks" id="task-diagnoses" style="display: none;">
				<header class="tasks-header">
					<span id="title-symptom" class="tasks-title">DIAGNOSIS</span>
					<a class="tasks-lists"></a>
				</header>
				
				<div class="symptoms-qualifiers" data-bind="foreach: signs">
					<select style="display: none" id="selectedDiagnosisList"></select>				
					<div class="symptom-container selectdiv" id="selected-diagnoses"></div>
				</div>
			</div>
		</fieldset>

		<fieldset style="min-width: 500px; width: auto">
			<legend>Procedure</legend>
			<input type="text" style="width:98.6%; margin-left:5px;" id="procedure" name="procedure" placeholder="Enter Procedure" />
			
			<p style="display: none">
				<input type="hidden" id="procedure-set" name="procedure-set" />
			</p>
			
			<div class="tasks" id="task-procedure" style="display: none;">
				<header class="tasks-header">
					<span id="title-symptom" class="tasks-title">PROCEDURES APPLIED</span>
					<a class="tasks-lists"></a>
				</header>
				
				<div class="symptoms-qualifiers" data-bind="foreach: signs">
					<select style="display: none" id="selectedProcedureList"></select>				
					<div class="symptom-container selectdiv" id="selected-procedures">						
						
					</div>
				</div>
			</div>
		</fieldset>

		<fieldset>
			<legend>Outcome</legend>
			<p>
				<label class="label title-label" style="width: auto; padding-left: 5px;">
					ADMISSION OUTCOME
					<span class="important"></span>
				</label>
				<select class="selectdiv" id="dischargeOutcomes" style="width:98.6%; margin: 0">
					<option value="">Select Outcome</option>
					<% if (listOutCome!=null && listOutCome!=""){ %>
					<% listOutCome.each { outCome -> %>
					<option  value="${outCome.id}">
						${outCome.answerConcept.name}
					</option>
					<% } %>
					<% } %>
				</select>
			</p>
		</fieldset>

		<fieldset>
			<legend>Other Instructions</legend>
			<p>
				<label class="label title-label" style="width: auto; padding-left: 5px;">
					OTHER INSTRUCTIONS
					<span class="important"></span>
				</label>
				<textarea id="otherDischargeInstructions" placeholder="Enter Other Instructions" style="height: 129px; width: 100%; resize: none;"></textarea>
				
				<input required name="dischargeAdmittedID" id="dischargeAdmittedID" value="${patientInformation.id}" type="hidden">
				<input name="dischargePatientID" id="dischargePatientID" value="${patient.id}" type="hidden">
			</p>
		</fieldset>
	</section>
	
	<div id="confirmation" style="min-height: 250px;">
		<span id="confirmation_label" class="title">Confirmation</span>
		
		<div id="confirmationQuestion" class="focused" style="margin-top:0px">		
			<p style="display: none"> 
				<button class="button submit confirm" style="display: none;"></button>
			</p>
			
			<div class="dashboard">
				<div class="info-section">
					<div class="info-header">
						<i class="icon-list-ul"></i>
						<h3>DISCHARGE SUMMARY &amp; CONFIRMATION</h3>
					</div>					
					
					<div class="info-body">
						<table id="summaryTable">
							<tbody>
								<tr>
									<td><span class="status active"></span>Diagnosis</td>
									<td>N/A</td>
								</tr>
								
								<tr>
									<td><span class="status active"></span>Procedure</td>
									<td>N/A</td>
								</tr>
								
								<tr>
									<td><span class="status active"></span>Outcome</td>
									<td>N/A</td>
								</tr>
								
								<tr>
									<td><span class="status active"></span>Instructions</td>
									<td>N/A</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>				
			</div>			
			
			<span value="Submit" class="button submit confirm right" id="dischargeSubmit" style="margin: 5px 10px;">
				<i class="icon-save small"></i>
				Save
			</span>
			
			<span id="cancelButton" class="button cancel" style="margin: 5px">
				<i class="icon-remove small"></i>			
				Cancel
			</span>
		</div>
	</div>
</form>
