<div class="dashboard">
	<div class="info-section" style="width: 99%;">
		<div class="info-header">
			<i class="icon-random"></i>
			<h3>TRANSFER PATIENT</h3>
		</div>
		
		<div class="info-body">
			<form method="post" id="transferForm">
				<div style="float: left">
					<img src="${ui.resourceLink('ipdapp', 'images/patient-transfer.png')}" style="border-right: 1px solid #eee; height: 185px; margin-right: 10px; padding: 5px 15px 0 5px;" />
				</div>
				
				<div style="display: block; overflow:hidden">
					<div class="daily-vitals">
						<label>Select Ward: </label>
						<span>
							<select required  name="transferIpdWard" id="transferIpdWard"  name="ipdWard">
								<option value="">Select Ward</option>
								
								<% if (listIpd!=null && listIpd!="") { %>
									<% listIpd.each { ipd -> %>
										<% if (ipd.answerConcept.id != patientInformation.admittedWard.id) { %>
											<option title="${ipd.answerConcept.name}"   value="${ipd.answerConcept.id}">
												${ipd.answerConcept.name}
											</option>										
										<%}%>
									<%}%>
								<%}%>
							</select>
						</span>
						
						<label>Select Doctor: </label>
						<span>
							<select required name="transferDoctor" id="transferDoctor"  name="doctor">
								<option value="">Select Doctor On Call</option>
								<% if (listDoctor!=null && listDoctor!=""){ %>
									<% listDoctor.each { doct -> %>
									<option title="${doct.givenName}"   value="${doct.id}">
										${doct.givenName}
									</option>
									<% } %>
								<% } %>
							</select>
						</span>
						
						<label>Bed Number</label>
						<span>
							<input required name="transferBedNumber" id="transferBedNumber" type="number"/>
						</span>
						
						<label>Comments</label>
						<span>
							<textarea name="transferComment" id="transferComment"></textarea>
						</span>
						
						<input required name="transferAdmittedID" id="transferAdmittedID" value="${patientInformation.id}" type="hidden">
						
						<label></label>
						<span style="margin-top: 5px">
							<a type="submit" class="button confirm" id="transferButton">
								<i class="icon-random"></i>
								Transfer
							</a>
						</span>
					</div>
				</div>
			</form>	
			<div class="clear"></div>
		</div>
	</div>
	
</div>
<div class="clear"></div>