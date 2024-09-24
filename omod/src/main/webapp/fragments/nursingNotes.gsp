<div class="dashboard">
	<div class="info-section" style="width: 99.5%;">
		<div class="info-header">
			<h3>NURSING NOTES</h3>

			<a class="right update-nursing-notes">
				<span>Update Nursing Notes</span>
				<i class="small chevron icon-chevron-right" style="font-size: 0.92em;"></i>
			</a>
		</div>

		<div class="info-body nursing-notes-edit-page" style="display: none;">
		<div>
			<div id="errorAlert" class="alert" style="display: none"><b>Please correct the following errors:</b><hr>
            	<ul id="errorsHere"></ul>
            </div>
        </div>
			<form method="post" id="nursingNotesForm" style="margin-bottom: 5px;">
				<div class="simple-form-ui">

					<div class="col12 daily-vitals" style="width: 80%">
						<div>
							<label>Notes</label>
							<span>
								<textarea name="nursingNotesDetails" id="nursingNotesDetails" placeholder="Notes if any" required="required"></textarea>
							</span>
						</div>

						<div style="margin-top: 10px">
							<input name="nursingNotesPatientID" id="nursingNotesPatientID" value="${patient.patientId}" type="hidden">

							<label></label>
							<a id="nursingNotesButton" name="nursingNotesButton" class="button confirm">
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

		<table id="nursingNotes" style="margin-top: 5px">
			<thead>
				<tr>
					<th style="width: 180px;">DATE</th>
					<th>NOTES</th>
					<th style="width: 120px;">CREATED BY</th>
				</tr>
			</thead>
			<tbody>
				<% if (nursingNotes.size() > 0){ %>
					<% nursingNotes.each { nursingNote -> %>
						<tr>
							<td>${ui.formatDatetimePretty(nursingNote.date)}</td>
							<td>${nursingNote.details}</td>
							<td>${nursingNote.medic}</td>
						</tr>
					<% } %>
				<% } else { %>
					<tr>
						<td colspan="3">No Nursing Notes</td>
					</tr>
				<% } %>
			</tbody>
		</table>
	</div>
</div>
<div class="clear"></div>