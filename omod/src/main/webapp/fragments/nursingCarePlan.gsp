<div class="dashboard">
	<div class="info-section" style="width: 99.5%;">
		<div class="info-header">
			<h3>NURSING CARE PLAN</h3>

			<a class="right update-nursing-care-plan">
				<span>Update Nursing Care Plan</span>
				<i class="small chevron icon-chevron-right" style="font-size: 0.92em;"></i>
			</a>
		</div>

		<div class="info-body nursing-care-plan-edit-page" style="display: none;">
		<div>
			<div id="errorAlert" class="alert" style="display: none"><b>Please correct the following errors:</b><hr>
            	<ul id="errorsHere"></ul>
            </div>
        </div>

			<form method="post" id="nursingCarePlanForm" style="margin-bottom: 5px;">
				<div class="simple-form-ui">

					<div class="col12 daily-vitals" style="width: 80%">
						<div>
							<label>Diagnosis</label>
							<span>
								<textarea name="nursingCarePlanDiagnosis" id="nursingCarePlanDiagnosis" placeholder="Diagnosis" required="required"></textarea>
							</span>
						</div>

						<div>
                        	<label>Objectives</label>
                        	<span>
                        	    <textarea name="nursingCarePlanObjectives" id="nursingCarePlanObjectives" placeholder="Objectives" required="required"></textarea>
                            </span>
                        </div>

                        <div>
                            <label>Expected Outcome</label>
                        	<span>
                        	    <textarea name="nursingCarePlanExpectedOutcome" id="nursingCarePlanExpectedOutcome" placeholder="Expected Outcome" required="required"></textarea>
                            </span>
                        </div>

                        <div>
                            <label>Intervention</label>
                        	<span>
                        	    <textarea name="nursingCarePlanIntervention" id="nursingCarePlanIntervention" placeholder="Intervention" required="required"></textarea>
                        	</span>
                        </div>

                        <div>
                            <label>Rationale</label>
                        	<span>
                        	    <textarea name="nursingCarePlanRationale" id="nursingCarePlanRationale" placeholder="Rationale" required="required"></textarea>
                        	</span>
                        </div>

                        <div>
                            <label>Evaluation</label>
                        	<span>
                        	    <textarea name="nursingCarePlanEvaluation" id="nursingCarePlanEvaluation" placeholder="Evaluation" required="required"></textarea>
                        	</span>
                        </div>

						<div style="margin-top: 10px">
							<input name="patientID" id="patientID" value="${patient.patientId}" type="hidden">

							<label></label>
							<a id="nursingCarePlanButton" name="nursingCarePlanButton" class="button confirm">
								<i class="icon-save small"></i>
								Save
							</a>
						</div>
					</div>

					<div class="clear"></div>
				</div>
			</form>
			<div class="clear"></div>
		</div>

		<table id="nursingCarePlan" style="margin-top: 5px">
			<thead>
				<tr>
					<th style="width: 180px;">DATE</th>
					<th>NURSING<br/>DIAGNOSIS</th>
					<th>OBJECTIVES</th>
					<th>EXPECTED<br/>OUTCOME</th>
					<th>INTERVENTION</th>
					<th>RATIONALE</th>
					<th>EVALUATION</th>
					<th style="width: 120px;">CREATED BY</th>
				</tr>
			</thead>
			<tbody>
				<% if (nursingCarePlans.size() > 0){ %>
					<% nursingCarePlans.each { nursingCarePlan -> %>
						<tr>
							<td>${ui.formatDatetimePretty(nursingCarePlan.date)}</td>
							<td>${nursingCarePlan.diagnosis}</td>
							<td>${nursingCarePlan.objectives}</td>
							<td>${nursingCarePlan.expectedOutcome}</td>
							<td>${nursingCarePlan.intervention}</td>
							<td>${nursingCarePlan.rationale}</td>
							<td>${nursingCarePlan.evaluation}</td>
							<td>${nursingCarePlan.medic}</td>
						</tr>
					<% } %>
				<% } else { %>
					<tr>
						<td colspan="8">No Nursing Care Plans</td>
					</tr>
				<% } %>
			</tbody>
		</table>
	</div>
</div>
<div class="clear"></div>