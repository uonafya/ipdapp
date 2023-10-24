<%
	ui.decorateWith("appui", "standardEmrPage", [title: "Patient Treatment"])

	ui.includeCss("ehrconfigs", "jquery.dataTables.min.css")
	ui.includeCss("ehrconfigs", "onepcssgrid.css")
	ui.includeCss("ehrconfigs", "referenceapplication.css")

	ui.includeCss("ehrinventoryapp", "main.css")
	ui.includeCss("ehrconfigs", "custom.css")

	ui.includeJavascript("kenyaui", "pagebus/simple/pagebus.js")
	ui.includeJavascript("kenyaui", "kenyaui-tabs.js")
	ui.includeJavascript("kenyaui", "kenyaui-legacy.js")
	ui.includeJavascript("ehrconfigs", "moment.js")
	ui.includeJavascript("ehrconfigs", "jquery.dataTables.min.js")
	ui.includeJavascript("ehrconfigs", "jq.browser.select.js")

	ui.includeJavascript("ehrconfigs", "knockout-2.2.1.js")
	ui.includeJavascript("ehrconfigs", "emr.js")
	ui.includeJavascript("ehrconfigs", "jquery.simplemodal.1.4.4.min.js")
%>

<%
    ui.includeCss("uicommons", "datetimepicker.css")
    ui.includeCss("ehrconfigs", "onepcssgrid.css")
    ui.includeCss("ehrconfigs", "custom.css")
    ui.includeJavascript("patientdashboardapp", "note.js")
    ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js")
    ui.includeJavascript("uicommons", "navigator/validators.js")
    ui.includeJavascript("uicommons", "navigator/navigator.js")
    ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js")
    ui.includeJavascript("uicommons", "navigator/navigatorModels.js")
    ui.includeJavascript("uicommons", "navigator/navigatorTemplates.js")
    ui.includeJavascript("uicommons", "navigator/exitHandlers.js")
    ui.includeJavascript("ipdapp", "knockout-3.4.0.js")

    ui.includeJavascript("ipdapp", "jq.print.js")
    ui.includeJavascript("ipdapp", "jq.slimscroll.js")
    ui.includeJavascript("ehrconfigs", "emr.js")
    ui.includeJavascript("uicommons", "jquery.simplemodal.1.4.4.min.js")

    ui.includeCss("ipdapp", "ipdapp.css");
    ui.includeCss("ehrconfigs", "referenceapplication.css")

	def fields = [
			[
					id: "facility",
					label: "",
					formFieldName: "facility",
					class: org.openmrs.Location
			]
	]
%>

${ ui.includeFragment("ipdapp", "treatmentAppScripts", [note: note, listOfWards: listOfWards, internalReferralSources: internalReferralSources, externalReferralSources: externalReferralSources, referralReasonsSources: referralReasonsSources, outcomeOptions: outcomeOptions ]) }



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
form input:focus, form select:focus, form textarea:focus, form ul.select:focus, .form input:focus, .form select:focus, .form textarea:focus, .form ul.select:focus,
.simple-form-ui section fieldset select:focus, .simple-form-ui section fieldset input:focus, .simple-form-ui section #confirmationQuestion select:focus, .simple-form-ui section #confirmationQuestion input:focus,
.simple-form-ui #confirmation fieldset select:focus, .simple-form-ui #confirmation fieldset input:focus, .simple-form-ui #confirmation #confirmationQuestion select:focus,
.simple-form-ui #confirmation #confirmationQuestion input:focus, .simple-form-ui form section fieldset select:focus, .simple-form-ui form section fieldset input:focus,
.simple-form-ui form section #confirmationQuestion select:focus, .simple-form-ui form section #confirmationQuestion input:focus, .simple-form-ui form #confirmation fieldset select:focus,
.simple-form-ui form #confirmation fieldset input:focus, .simple-form-ui form #confirmation #confirmationQuestion select:focus, .simple-form-ui form #confirmation #confirmationQuestion input:focus {
	outline: 0px none #007fff;
	box-shadow: 0 0 0 0 #888;
}
#formBreadcrumb{
	background: #fff;
}
#treatmentForm{
	background: #f9f9f9 none repeat scroll 0 0;
	margin-top: 3px;
	display: flex;
	flex-direction: column;
	justify-content: space-around;
	align-items: center;
}
#charges-info{
	display: flex;
	flex-direction: column;
	max-width: 1024px;
	width: 100%;
}
#confirmation {
	min-height: 250px;
	width: 100%;
	max-width: 1024px;
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

<style>
	.dialog textarea{
		resize: none;
	}

	.dialog li label span {
		color: #f00;
		float: right;
		margin-right: 10px;
	}
	.icon-remove{
		cursor: pointer!important;
	}
	.diagnosis-carrier-div{
		border-width: 1px 1px 1px 10px;
		border-style: solid;
		border-color: #404040;
		padding: 0px 10px 3px;
	}
	#diagnosis-carrier input[type="radio"] {
		-webkit-appearance: checkbox;
		-moz-appearance: checkbox;
		-ms-appearance: checkbox;
	}
    #prescriptionAlert {
        text-align: center;
        border:     1px #f00 solid;
        color:      #f00;
        padding:    5px 0;
    }
	.alert{
		position: relative;
		padding: .75rem 1.25rem;
		margin-bottom: 1rem;
		border: 1px solid transparent;
		border-top-color: transparent;
		border-right-color: transparent;
		border-bottom-color: transparent;
		border-left-color: transparent;
		border-top-color: transparent;
		border-right-color: transparent;
		border-bottom-color: transparent;
		border-left-color: transparent;
		border-radius: .25rem;
		color: #721c24;
		background-color: #f8d7da;
		border-color: #f5c6cb;
	}
</style>

<div class="example">
	<ul id="breadcrumbs">
		<li>
			<a href="${ui.pageLink('ipdapp','chooseIpdWard')}">
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
			Treatment
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
		<span>${ipdNumber}</span>
		<br>

		<div class="catg">
			<i class="icon-tags small" style="font-size: 16px"></i><small>Category:</small> ${category}/${subCategory}
		</div>
	</div>
	<div class="clear"></div>
</div>

<div id="content">
    <form method="post" id="notes-form" class="simple-form-ui">
        <section>
            <span class="title">Continuation Notes</span>
			<fieldset class="no-confirmation">
				<legend>Symptoms</legend>

				<div style="padding: 0 4px">
					<label for="symptom" class="label">Symptoms <span class="important">*</span></label>
					<input type="text" id="symptom" name="symptom" placeholder="Add Symptoms" />
					<field>
						<input type="hidden" id="symptoms-set" class="required"/>
						<span id="symptoms-lbl" class="field-error" style="display: none"></span>
					</field>
				</div>

				<div class="tasks" id="task-symptom" style="display:none;">
					<header class="tasks-header">
						<span id="title-symptom" class="tasks-title">PATIENT'S SYMPTOMS</span>
						<a class="tasks-lists"></a>
					</header>

					<div class="symptoms-qualifiers" data-bind="foreach: signs" >
						<div class="symptom-container">
							<div class="symptom-label">
								<span class="right pointer show-qualifiers"><i class="icon-caret-down small" title="more"></i></span>
								<span class="right pointer" data-bind="click: \$root.removeSign"><i class="icon-remove small"></i></span>
								<span data-bind="text: label"></span>
							</div>

							<div class="qualifier-container" style="display: none;">
								<ul class="qualifier" data-bind="foreach: qualifiers">
									<li>
										<span data-bind="text: label"></span>
										<div data-bind="if: options().length >= 1">
											<div data-bind="foreach: options" class="qualifier-option">
												<p class="qualifier-field">
													<input type="radio" data-bind="checkedValue: \$data, checked: \$parent.answer" >
													<label data-bind="text: label"></label>
												</p>
											</div>
										</div>
										<div data-bind="if: options().length === 0" >
											<p>
												<input type="text" data-bind="value: freeText" >
											</p>
										</div>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>History</legend>
				<p>
					<label class="label" for="history">History of present illness</label>
					<span>
						Date of Onset<input type="date" id="date_of_onset_for_crrent_illnes"/>
					</span>
					<textarea data-bind="value: \$root.illnessHistory" id="history" name="history" rows="10" cols="74"></textarea>
				</p>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>Physical Examination</legend>
				<p class="input-position-class">
					<label class="label">Physical Examination <span class="important">*</span></label>
					<field>
						<textarea data-bind="value: \$root.physicalExamination" id="examination" name="examination" rows="10" cols="74" class="required"></textarea>
						<span id="examination-lbl" class="field-error" style="display: none"></span>
					</field>
				</p>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>Diagnosis</legend>
				<div>
					<h2>Patient's Diagnosis <span class="important">*</span></h2>

					<div>
						<p class="input-position-class">
							<input type="text" id="diagnosis" name="diagnosis" placeholder="Select Diagnosis" />
						</p>

						<div id="task-diagnosis" class="tasks" style="display:none;">
							<header class="tasks-header">
								<span id="title-diagnosis" class="tasks-title">DIAGNOSIS</span>
								<a class="tasks-lists"></a>
							</header>

							<div id="diagnosis-carrier" data-bind="foreach: diagnoses" style="margin-top: -2px">
								<div class="diagnosis-container" style="border-top: medium none !important;">
									<span class="right pointer" data-bind="click: \$root.removeDiagnosis"><i class="icon-remove small"></i></span>
									<div class="diagnosis-carrier-div" style="border-width: 1px 1px 1px 10px; border-style: solid; border-color: -moz-use-text-color; padding: 0px 10px 3px;">
										<span data-bind="text: label" style="display: block; font-weight: bold;"></span>

										<label style="display: inline-block; font-size: 11px; padding: 0px; cursor: pointer; margin: 0px 0px 0px -5px;">
											<input value="true"  data-bind="checked: provisional" class="chk-provisional" type="radio" style="margin-top: 3px"/>Provisional
										</label>

										<label style="display: inline-block; font-size: 11px; padding: 0px; cursor: pointer; margin: 0">
											<input value="false" data-bind="checked: provisional" class="chk-final" type="radio" style="margin-top: 3px"/>Final
										</label>
									</div>

								</div>
							</div>
						</div>

						<p class="input-position-class">
							<field>
								<input type="hidden" id="diagnosis-set" class="required" />
								<span id="diagnosis-lbl" class="field-error" style="display: none"></span>
							</field>
						</p>
					</div>
				</div>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>Procedures</legend>
				<div class="input-position-class">
					<label class="label" for="procedure">Patient Procedures</label>
					<input type="text" id="procedure" name="procedure" placeholder="Specify a Procedure" />
				</div>

				<div id="task-procedure" class="tasks" style="display:none;">
					<header class="tasks-header">
						<span id="title-procedure" class="tasks-title">PROCEDURES</span>
						<a class="tasks-lists"></a>
					</header>

					<div data-bind="foreach: procedures">
						<div class="procedure-container">
							<span class="right pointer" data-bind="click: \$root.removeProcedure"><i class="icon-remove small"></i></span>
							<p data-bind="text: label"></p>
							<span data-bind="if: schedulable">Schedule:<input type="date"></span>
						</div>
					</div>
				</div>
				<p>
					<input type="hidden" id="procedure-set" />
				</p>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>Investigations</legend>
				<div>
					<div class="input-position-class">
						<label class="label" for="investigation">Investigation:</label>
						<input type="text" id="investigation" name="investigation" />
					</div>

					<div id="task-investigation" class="tasks" style="display:none;">
						<header class="tasks-header">
							<span id="title-investigation" class="tasks-title">INVESTIGATION</span>
							<a class="tasks-lists"></a>
						</header>

						<div data-bind="foreach: investigations">
							<div class="investigation-container">
								<span class="right pointer" data-bind="click: \$root.removeInvestigation"><i class="icon-remove small"></i></span>
								<p data-bind="text: label"></p>
							</div>
						</div>
					</div>
					<div style="display:none">
						<p><input type="text" ></p>
					</div>
				<p>
					<input type="hidden" id="investigation-set" />
				</p>
				</div>
			</fieldset>
			<fieldset class="no-confirmation">
				<legend>Prescription</legend>
				<div>
					<div style="display:none">
						<p><input type="text"></p>
					</div>
					<h2>Prescribe Medicine</h2>
					<table id="addDrugsTable">
						<thead>
							<tr>
								<th>Drug Name</th>
								<th>Dosage</th>
								<th>Formulation</th>
								<th>Frequency</th>
								<th>Days</th>
								<th>Comments</th>
								<th></th>
							</tr>
						</thead>
						<tbody data-bind="foreach: drugs">
							<tr>
								<td data-bind="text: drugName"></td>
								<td data-bind="text: dosageAndUnit" ></td>
								<td data-bind="text: formulation().label"></td>
								<td data-bind="text: frequency().label"></td>
								<td data-bind="text: numberOfDays"></td>
								<td data-bind="text: comment"></td>
								<td>
									<a href="#" title="Remove">
										<i data-bind="click: \$root.removePrescription" class="icon-remove small" style="color: red" ></i>
									</a>
									<!-- <a href="#"><i class="icon-edit small"></i></a> -->
								</td>
							</tr>
						</tbody>
					</table>
					<br/>
					<button id="add-prescription">Add</button>
				</div>
				<p>
					<input type="hidden" id="drug-set" />
				</p>
			</fieldset>
			<fieldset class="no-confirmation">
				<legend>Other Instructions</legend>
				<p class="input-position-class">
					<label class="label">Other Instructions</label>
					<textarea data-bind="value: \$root.otherInstructions" id="instructions" name="instructions" rows="10" cols="74"></textarea>
				</p>
			</fieldset>

			<fieldset class="no-confirmation">
				<legend>Outcome</legend>
				<div>
					<div class="onerow" style="padding-top:2px;">
						<h2>What is the outcome of this visit? <span class="important">*</span></h2>
						<div data-bind="foreach: availableOutcomes" class="outcomes-container">
							<div data-bind="if: !(\$root.admitted !== false && \$data.id !== 2)">
								<p class="outcome">
									<label style="display: inline-block;">
										<input type="radio" name="outcome" data-bind="click: updateOutcome"/>
										<span data-bind="text: option.label" style="color:#000; font-size: 1em; cursor: pointer"></span>
									</label>
									<span data-bind="if: \$data.option.id === 1 && \$root.outcome() && \$root.outcome().option.id === 1">
										<span id="follow-up-date" class="date" style="float: right;">
											<input data-bind="value : followUpDate" style="width: 378px;" class="required">
											<span class="add-on"><i class="icon-calendar small"></i></span>
										</span>
									</span>

									<span data-bind="if: \$data.option.id === 2 && \$root.outcome() && \$root.outcome().option.id === 2">
										<select data-bind="options: \$root.inpatientWards, optionsText: 'label', value: admitTo" style="width: 400px !important; float: right;"></select>
									</span>

								</p>
							</div>
						</div>
						<span data-bind="if: \$root.outcome() && \$root.outcome().option.id ===6">
							<h2>Referral information</h2>

							<div class="onerow">
								<div class="col4"><label for="internalReferral"						>Referral Available</label></div>
								<div class="col4"><label for="internalReferral" id="refTitle"		>Internal Referral</label></div>
								<div class="col4 last"><label for="internalReferral" id="facTitle"	>Facility</label></div>
							</div>

							<div class="onerow">
								<div class="col4">
									<div class="input-position-class">
										<select id="availableReferral" name="availableReferral">
											<option value="0">Select Option</option>
											<option value="1">Internal Referral</option>
											<option value="2">External Referral</option>
										</select>
									</div>
								</div>

								<div class="col4">
									<div class="input-position-class">
										<select id="internalReferral" name="internalReferral" data-bind="options: \$root.internalReferralOptions, optionsText: 'label', value: \$root.referredTo, optionsCaption: 'Please select...'">
										</select>

										<select id="externalReferral" name="externalReferral" onchange="loadExternalReferralCases();" data-bind="options: \$root.externalReferralOptions, optionsText: 'label', value: \$root.referredTo, optionsCaption: 'Please select...'">
										</select>
									</div>
								</div>

								<div class="col4 last">
									<div class="input-position-class">
										<field>
											<% fields.each { %>
											${ ui.includeFragment("kenyaui", "widget/labeledField", it) }
											<% } %>
										</field>
									</div>
								</div>
							</div>

							<div class="onerow" style="padding-top:2px;" id="refReason1">
								<div class="col4">
									<label for="referralReasons" style="margin-top:20px;">Referral Reasons</label>
								</div>

								<label id="specify-lbl" for="specify" style="margin-top:20px;">If Other, Please Specify</label>
							</div>

							<div class="onerow" style="padding-top:2px;" id="refReason2">
								<div class="col4">
									<select id="referralReasons" name="referralReasons" data-bind="options: \$root.referralReasonsOptions, optionsText: 'label', value: \$root.referralReasons, optionsCaption: 'Please select...'" style="margin-top: 5px;">
									</select>
								</div>

								<div class="col4 last" style="width: 65%;">
									<input type="text" id="specify" placeholder="Please Specify" name="specify" data-bind="value: \$root.specify"/>
								</div>
							</div>

							<div class="onerow" style="padding-top:2px;" id="refReason3">
								<label for="referralComments" style="margin-top:20px;">Comments</label>
								<textarea type="text" id="referralComments"   name="referralComments" data-bind="value: \$root.referralComments" placeholder="COMMENTS"  style="height: 80px; width: 650px;"></textarea>
							</div>
						</span>

					</div>

					<field>
						<input type="hidden" id="outcome-set" class="required" />
						<span id="outcome-lbl" class="field-error" style="display: none"></span>
					</field>

				</div>
			</fieldset>
		</section>

		<div id="confirmation" style="width:74.6%; min-height: 400px;">
			<span id="confirmation_label" class="title">Confirmation</span>

			<div class="dashboard">
				<div class="info-section">
					<div class="info-header">
						<i class="icon-list-ul"></i>
						<h3>CONTINUATION NOTES SUMMARY & CONFIRMATION</h3>
					</div>

					<div class="info-body">
						<table id="summaryTable">
							<tr>
								<td><span class="status active"></span>Symptoms</td>
								<td data-bind="foreach: signs">
									<span data-bind="text: label"></span>
									<span data-bind="if: (\$index() !== (\$parent.signs().length - 1))"><br/></span>
								</td>
							</tr>

							<tr>
								<td><span class="status active"></span>History</td>
								<td>N/A</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Physical Examination</td>
								<td>N/A</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Diagnosis</td>
								<td data-bind="foreach: diagnoses">
									<span data-bind="text: label"></span>
									<span data-bind="if: (\$index() !== (\$parent.diagnoses().length - 1))"><br/></span>
								</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Procedures</td>
								<td>
									<span data-bind="foreach: procedures">
										<span data-bind="text: label"></span>
										<span data-bind="if: (\$index() !== (\$parent.procedures().length - 1))"><br/></span>
									</span>
									<span data-bind="if: (procedures().length === 0)">N/A</span>
								</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Investigations</td>
								<td>
									<span data-bind="foreach: investigations">
										<span data-bind="text: label"></span>
										<span data-bind="if: (\$index() !== (\$parent.investigations().length - 1))"><br/></span>
									</span>
									<span data-bind="if: (investigations().length === 0)">N/A</span>
								</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Prescriptions</td>
								<td>
									<span data-bind="foreach: drugs">
										<span data-bind="text: drugName()+' '+formulation().label"></span>
										<span data-bind="if: (\$index() !== (\$parent.drugs().length - 1))"><br/></span>
									</span>
									<span data-bind="if: (drugs().length === 0)">N/A</span>
								</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Instructions</td>
								<td>N/A</td>
							</tr>

							<tr>
								<td><span class="status active"></span>Outcome</td>
								<td>N/A</td>
							</tr>
						</table>
					</div>
				</div>
			</div>

			<div id="confirmationQuestion">
				<p style="display: inline;">
					<button class="submitButton confirm" style="float: right">Submit</button>
				</p>

				<button id="cancelButton" class="cancel cancelButton" style="margin-left: 5px;">Cancel</button>
				<p style="display: inline">&nbsp;</p>
			</div>
		</div>
    </form>
</div>
<div id="confirmDialog" class="dialog" style="display: none;">
        <div class="dialog-header">
            <i class="icon-save"></i>
            <h3>Confirm</h3>
        </div>


        <div class="dialog-content">
            <h3>Cancelling will lead to loss of data,are you sure you want to do this?</h3>

            <span  class="button confirm right" style="float: right">Confrim</span>
            <span class="button cancel" >Cancel</span>
        </div>
    </div>

<div id="prescription-dialog" class="dialog" style="display:none;">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>

        <h3>Prescription</h3>
    </div>

    <div class="dialog-content">
        <ul>
            <li id="prescriptionAlert">
                <div>No batches found in Pharmacy for the Selected Drug/Formulation combination</div>
            </li>

            <li>
                <label>Drug<span>*</span></label>
                <input class="drug-name" id="drugSearch" type="text" data-bind="value: prescription.drug().drugName, valueUpdate: 'blur'">
            </li>
            <li>
                <label>Dosage<span>*</span></label>
                <input type="text" class="drug-dosage" data-bind="value: prescription.drug().dosage" style="width: 60px!important;">
                <select id="dosage-unit" class="drug-dosage-unit" data-bind="options: prescription.drug().drugUnitsOptions, value: prescription.drug().drugUnit, optionsText: 'label',  optionsCaption: 'Select Unit'" style="width: 191px!important;"></select>
            </li>

            <li>
                <label>Formulation<span>*</span></label>
                <select id="drugFormulation" class="drug-formulation" data-bind="options: prescription.drug().formulationOpts, value: prescription.drug().formulation, optionsText: 'label',  optionsCaption: 'Select Formulation'"></select>
            </li>
            <li>
                <label>Frequency<span>*</span></label>
                <select class="drug-frequency" data-bind="options: prescription.drug().frequencyOpts, value: prescription.drug().frequency, optionsText: 'label',  optionsCaption: 'Select Frequency'"></select>
            </li>

            <li>
                <label>No. 0f Days<span>*</span></label>
                <input type="text" class="drug-number-of-days" data-bind="value: prescription.drug().numberOfDays">
            </li>
            <li>
                <label>Comment</label>
                <textarea class="drug-comment" data-bind="value: prescription.drug().comment"></textarea>
            </li>
        </ul>

        <label class="button confirm right">Confirm</label>
        <label class="button cancel">Cancel</label>
    </div>
</div>

<script>
	var prescription = {drug: ko.observable(new Drug())};
	ko.applyBindings(prescription, jq("#prescription-dialog")[0]);
</script>

