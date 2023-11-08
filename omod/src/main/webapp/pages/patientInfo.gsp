<%
	ui.decorateWith("appui", "standardEmrPage", [title: "Patient Details"])
	ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
	ui.includeJavascript("patientdashboardapp", "jq.print.js")
	ui.includeJavascript("patientdashboardapp", "jq.slimscroll.js")
	ui.includeJavascript("ehrconfigs", "emr.js")
	ui.includeJavascript("ipdapp", "charts.js")
	ui.includeCss("ehrconfigs", "referenceapplication.css")

%>

<script>
	var getJSON = function (dataToParse) {
		if (typeof dataToParse === "string") {
			return JSON.parse(dataToParse);
		}
		return dataToParse;
	}



	function setBedNo(bedNum){
		jq('#transferBedNumber').val(bedNum)
		jq('#addDrugDialog').addClass('hidden')
	}

	jq(function() {
		jq("#transferIpdWard").on("change",function () {
			var currentID = jq(this).val();


			jq.getJSON('${ ui.actionLink("ipdapp", "BedStrength", "getBedStrength")  }',{
				wardId: currentID
			})
					.success(function(data) {

						var pasteBed = '';
						jq('#dump-bed').html('');

						for (var key in data) {
							if (data.hasOwnProperty(key)) {
								var val = data[key];

								for(var i in val){
									if(val.hasOwnProperty(i)){
										var j = val[i];

										pasteBed += '<div class="bp-container" onclick="setBedNo('+i+')" data-bednum="'+i+'" data-people="'+j+'"> <span class="bp-span bno">Bed <b>#' + i + '</b></span> <span class="bp-span bpl" >Patients: <b>' + j+'</b></span></div>';
									}
								}

							}
						}


						jq('#dump-bed').html(pasteBed);

					})
					.error(function(xhr, status, err) {
						jq().toastmessage('showErrorToast', "Error:" + err);
					})
		});

		jq("#transferBedNumber").on("click", function(e) {
			jq('#addDrugDialog').removeClass('hidden')
		});
	});

	jq(function() {
		jq("#tabs").tabs();

		jq('.update-vitals').click(function(){
			if (jq('.update-vitals i').attr('class').indexOf('icon-chevron-right') >= 0){
				jq('.update-vitals i').removeClass('icon-chevron-right');
				jq('.update-vitals i').addClass('icon-chevron-down');

				jq('.update-vitals span').text('Cancel Edit');
				jq('.vitals-edit-page').show(200);
			}
			else{
				jq('.update-vitals i').removeClass('icon-chevron-down');
				jq('.update-vitals i').addClass('icon-chevron-right');

				jq('.update-vitals span').text('Update Vitals');
				jq('.vitals-edit-page').hide(300);

				jq('#vitalStatisticsForm')[0].reset();
			}
		});


		jq('.update-nursing-notes').click(function(){
        	if (jq('.update-nursing-notes i').attr('class').indexOf('icon-chevron-right') >= 0){
        	    jq('.update-nursing-notes i').removeClass('icon-chevron-right');
        		jq('.update-nursing-notes i').addClass('icon-chevron-down');

        		jq('.update-nursing-notes span').text('Cancel Edit');
        		jq('.nursing-notes-edit-page').show(200);
        	} else {
        		jq('.update-nursing-notes i').removeClass('icon-chevron-down');
        		jq('.update-nursing-notes i').addClass('icon-chevron-right');

        		jq('.update-nursing-notes span').text('Update Nursing Notes');
        		jq('.nursing-notes-edit-page').hide(300);

        		jq('#nursingNotesForm')[0].reset();
        	}
        });

        jq('.update-nursing-care-plan').click(function(){
                	if (jq('.update-nursing-care-plan i').attr('class').indexOf('icon-chevron-right') >= 0){
                	    jq('.update-nursing-care-plan i').removeClass('icon-chevron-right');
                		jq('.update-nursing-care-plan i').addClass('icon-chevron-down');

                		jq('.update-nursing-care-plan span').text('Cancel Edit');
                		jq('.nursing-care-plan-edit-page').show(200);
                	} else {
                		jq('.update-nursing-care-plan i').removeClass('icon-chevron-down');
                		jq('.update-nursing-care-plan i').addClass('icon-chevron-right');

                		jq('.update-nursing-care-plan span').text('Update Nursing Notes');
                		jq('.nursing-care-plan-edit-page').hide(300);

                		jq('#nursingCarePlanForm')[0].reset();
                	}
                });

		var requestType = localStorage.getItem('requestType');
		if(requestType=="discharge"){
			jq().toastmessage('showSuccessToast', "Patient discharge request sent!");
		}
		else if(requestType=="abscond") {
			jq().toastmessage('showSuccessToast', "Abscond Status appended on the Patient!");
		}
		localStorage.removeItem('requestType');

		jq("#transferButton").click(function(event){
			var transferForm = jq("#transferForm");
			var transferFormData = {
				'admittedId': jq('#transferAdmittedID').val(),
				'toWard': jq('#transferIpdWard').val(),
				'doctor': jq('#transferDoctor').val(),
				'bedNumber': jq('#transferBedNumber').val(),
				'comments': jq('#transferComment').val(),
			};

			if (transferFormData.toWard == ""){
				jq().toastmessage('showErrorToast', "Please specify Destination Ward");
				return false;
			}

			if (transferFormData.bedNumber == ""){
				jq().toastmessage('showErrorToast', "Please specify Destination Bed Number");
				return false;
			}

			if (transferFormData.bedNumber == ""){
				jq().toastmessage('showErrorToast', "Please specify Destination Bed Number");
				return false;
			}

			transferForm.submit(
					jq.getJSON('${ ui.actionLink("ipdapp", "PatientInfo", "transferPatient") }',transferFormData)
							.success(function(data) {
								jq().toastmessage('showSuccessToast', "Patient has been successfully transferred");
								window.location.href = "patientsAdmission.page?ipdWard=${patientInformation.admittedWard}";

							})
							.error(function(xhr, status, err) {
								jq().toastmessage('showErrorToast', "Error:" + err);
							})
			);

		});

		jq(document).ready(function () {
			checkVitalsFilled();
		});

		var errorList ={};
		 jq("input[type='number']").on("keyup", function() {
            var inputText = jq(this).val();
            inputText = inputText.replace(/[^0-9.]/g, '');
            jq(this).val(inputText);
        });

		 jq('#vitalStatisticsSystolicBloodPressure').on("focusout", function() {
            var maxVal = 250;
            var minVal = 0;
            var fieldTypeVal = "Blood Pressure (Systolic)";
            var idVal = jq(this).attr("id");
            var localid = "systolicValid";
            checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
        });

        jq('#vitalStatisticsDiastolicBloodPressure').on("focusout", function() {
            var maxVal = 150;
            var minVal = 0;
            var fieldTypeVal = "Blood Pressure (Diastolic)";
            var idVal = jq(this).attr("id")
            var localid = "diastolicValid";
            checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
        });

		jq('#vitalStatisticsTemperature').on("focusout", function(){
            var maxVal =43;
            var minVal=25;
            var fieldTypeVal="Temperature";
            var idVal = jq(this).attr("id");
            var localid ="tempValid";
            checkError(minVal,maxVal,idVal,localid,fieldTypeVal);
        });

		jq('#vitalStatisticsPulseRate').on("focusout", function() {
            var maxVal = 230;
            var minVal = 0;
            var fieldTypeVal = "Pulse Rate";
            var idVal = jq(this).attr("id")
            var localid = "pulseValid";
            checkError(minVal, maxVal, idVal, localid, fieldTypeVal);
        });

		function checkError(minVal, maxVal, idField, idError, fieldType) {
            var tempVal = jq('#'+idField).val();
            var errorLocal = '';
            var valTemp = 0;
            if (isNaN(tempVal) && tempVal !== "") {
                jq("#"+idError).html('<span style="color:#ff0000">' + fieldType + ' must be a number!</span>');
                jq("#"+idError).show();
                jq('#'+idField).attr("validation","false");
                errorList[fieldType]= "<i>"+fieldType+" must be a number</i><br>";
            } else if (tempVal > maxVal && !isNaN(tempVal)) {
                errorLocal = 'greater';
                valTemp = maxVal;
                jq('#'+idField).attr("validation","false");
            } else if (tempVal < minVal && !isNaN(tempVal)) {
                errorLocal = 'lower';
                valTemp = minVal;
                jq('#'+idField).attr("validation","false");
            } else {
                if (tempVal === "" && jq('#'+idField).attr("required")==="required") {
                    jq("#"+idField).prop("style", "border-color:red");
                    jq("#"+idError).html('<span style="color:#ff0000">' + fieldType + ' must be filled in!</span>');
                    jq("#"+idError).show();
                    jq("#"+idField).prop("style", "background-color: #f2bebe;");
                    jq('#'+idField).attr("validation","false");
                    errorList[fieldType]= "<i>"+fieldType+" must be filled in!</i><br/>";
                } else {
                    delete errorList[fieldType];
                    noError(idError, idField);
                }
                checkVitalsFilled();
                return;
        }

        jq("#"+idField).prop("style", "border-color:red");
        jq("#"+idError).html('<span style="color:#ff0000">' + fieldType + ' cannot be ' + errorLocal + ' than ' + valTemp + '</span>');
        jq("#"+idError).show();
        jq("#"+idField).prop("style", "background-color: #f2bebe;");
        errorList[fieldType]= '<i>'+fieldType+' cannot be ' + errorLocal + ' than ' + valTemp + '</i></br>';
        checkVitalsFilled();
    }

    function noError(idField, fieldTypeid) {
        jq('#'+idField).attr("validation","true");
        jq("#"+fieldTypeid).prop("style", "background-color: #ddffdd;");
        jq("#"+idField).hide();
        jq('#'+fieldTypeid).attr("validation","true");
    }

    function checkVitalsFilled() {
        var checkComplete = true;
        jq("form#vitalStatisticsForm :input[required]").map(function(idx, elem) {
            if(jq(this).attr('id')!="vitalStatisticsDietAdvised"){
					if(jq(elem).val()==''){
                	checkComplete=false;
            }
			}
        }).get();

        jq("form#vitalStatisticsForm :input[validation='false']").map(function(idx, elem) {
            if(jq(elem).attr("validation")==='false'){
                checkComplete=false;
            }
        }).get();
        if (checkComplete) {
            jq("#vitalStatisticsButton").removeClass("disabled");
            jq("#errorsHere").html("");
            jq("#errorAlert").hide();
            errorList={};
        }
        else{
            jq("#vitalStatisticsButton").addClass("disabled");
            var count = 0;
            var i;
            var allErrors='';
            for (i in errorList) {
                if (errorList.hasOwnProperty(i)) {
                    count++;
                    allErrors+=errorList[i];
                }
            }
            if(count!==0) {
                jq("#errorsHere").html(allErrors);
                jq("#errorAlert").show();
            }
        }
		return checkComplete;
    }


	    jq("#vitalStatisticsButton").click(function(event){
			var vitalStatisticsForm = jq("#vitalStatisticsForm");
			var vitalStatisticsFormData = {
				'admittedId': jq('#vitalStatisticsAdmittedID').val(),
				'patientId': jq('#vitalStatisticsPatientID').val(),
				'systolicBloodPressure':jq('#vitalStatisticsSystolicBloodPressure').val(),
				'diastolicBloodPressure': jq('#vitalStatisticsDiastolicBloodPressure').val(),
				'pulseRate': jq('#vitalStatisticsPulseRate').val(),
				'temperature': jq('#vitalStatisticsTemperature').val(),
				'dietAdvised': jq('#vitalStatisticsDietAdvised').val(),
				'notes': jq('#vitalStatisticsComment').val(),
				'ipdWard': jq('#vitalStatisticsIPDWard').val(),
			};

			if (checkVitalsFilled()) {
                vitalStatisticsForm.submit(
                        jq.getJSON('${ ui.actionLink("ipdapp", "PatientInfo", "saveVitalStatistics") }',vitalStatisticsFormData)
                                .success(function(data) {
                                    kenyaui.notifySuccess("Success! Vitals have been updated");
                                    location.reload();
                                })
                                .error(function(xhr, status, err) {
                                    jq().toastmessage('showErrorToast', "Error:" + err);
                                })
                );
			} else {
				kenyaui.notifyError("Cannot submit! Please Rectify Errors first");
			}
		});

		function checkNursingNotesFilled() {
                var checkComplete = true;
                jq("form#nursingNotesForm :input[required]").map(function(idx, elem) {
                    if(jq(this).attr('id')!="nursingNotesDetails"){
        				if(jq(elem).val()==''){
                        	checkComplete=false;
                        }
        			}
                }).get();

                jq("form#nursingNotesForm :input[validation='false']").map(function(idx, elem) {
                    if(jq(elem).attr("validation")==='false'){
                        checkComplete=false;
                    }
                }).get();

                if (checkComplete) {
                    jq("#nursingNotesButton").removeClass("disabled");
                    jq("#errorsHere").html("");
                    jq("#errorAlert").hide();
                    errorList={};
                }
                else{
                    jq("#nursingNotesButton").addClass("disabled");
                    var count = 0;
                    var i;
                    var allErrors='';
                    for (i in errorList) {
                        if (errorList.hasOwnProperty(i)) {
                            count++;
                            allErrors+=errorList[i];
                        }
                    }
                    if(count!==0) {
                        jq("#errorsHere").html(allErrors);
                        jq("#errorAlert").show();
                    }
                }
        		return checkComplete;
            }


		jq("#nursingNotesButton").click(function(event){
        	var nursingNotesForm = jq("#nursingNotesForm");
        	var nursingNotesFormData = {
        		'patientId': jq('#nursingNotesPatientID').val(),
        		'details': jq('#nursingNotesDetails').val(),
        	};
            nursingNotesForm.submit(
                 jq.getJSON('${ ui.actionLink("ipdapp", "NursingNotes", "saveNursingNotes") }', nursingNotesFormData)
                    .success(function(data) {
                        kenyaui.notifySuccess("Success! Nursing Notes have been updated");
                        location.reload();
                    })
                    .error(function(xhr, status, err) {
                        jq().toastmessage('showErrorToast', "Error:" + err);
                     })
                 );
        });

        jq("#nursingCarePlanButton").click(function(event){
                	var nursingCarePlanForm = jq("#nursingCarePlanForm");
                	var nursingCarePlanFormData = {
                		'patientId': jq('#nursingCarePlanPatientID').val(),
                		'diagnosis': jq('#nursingCarePlanDiagnosis').val(),
                		'objectives': jq('#nursingCarePlanObjectives').val(),
                		'expectedOutcome': jq('#nursingCarePlanExpectedOutcome').val(),
                		'intervention': jq('#nursingCarePlanIntervention').val(),
                		'rationale': jq('#nursingCarePlanRationale').val(),
                		'evaluation': jq('#nursingCarePlanEvaluation').val(),
                	};
                    nursingCarePlanForm.submit(
                         jq.getJSON('${ ui.actionLink("ipdapp", "NursingCarePlan", "saveNursingCarePlan") }', nursingCarePlanFormData)
                            .success(function(data) {
                                kenyaui.notifySuccess("Success! Nursing Care Plan have been updated");
                                location.reload();
                            })
                            .error(function(xhr, status, err) {
                                jq().toastmessage('showErrorToast', "Error:" + err);
                             })
                         );
                });


	});

	//dicharge patient send post information
    jq("#dischargeSubmit").click(function(event){
        var dischargeForm = jq("#dischargeForm");

    			//fetch the selected discharge diagnoses and store in an array
    			var selectedDiag = new Array;

    			jq("#selectedDiagnosisList option").each  ( function() {
    				selectedDiag.push ( jq(this).val() );
    			});

    			//get the list of selected procedures and store them in an array
    			var selectedDischargeProcedureList = new Array;

    			jq("#selectedDischargeProcedureList option").each  ( function() {
    				selectedDischargeProcedureList.push ( jq(this).val() );
    			});



    			var dischargeFormData = {
    				'dischargeAdmittedID': jq('#dischargeAdmittedID').val(),
    				'patientId': jq('#dischargePatientID').val(),
    				'selectedDiagnosisList': selectedDiag,
    				'selectedDischargeProcedureList': selectedDischargeProcedureList,
    				'dischargeOutcomes': jq('#dischargeOutcomes').val(),
    				'otherDischargeInstructions': jq('#otherDischargeInstructions').val(),
    			};

    			dischargeForm.submit(
    					jq.getJSON('${ ui.actionLink("ipdapp", "PatientInfo", "dischargePatient") }',dischargeFormData)
    							.success(function(data) {
    								jq().toastmessage('showNoticeToast', "Discharge form  submitted");
    							})
    							.error(function(xhr, status, err) {
    								jq().toastmessage('showErrorToast', "Error:" + err);
    							})
    			);

    });

	//reqeust for discharge
	function requestForDischarge(id, obStatus) {
		var dischargeData = {
			'id': id,
			'obStatus':obStatus
		};

		jq.getJSON('${ ui.actionLink("ipdapp", "patientInfo", "requestForDischarge") }', dischargeData)
				.success(function (data) {
					localStorage.setItem('requestType',"discharge");
					location.reload();
				})
				.error(function (xhr, status, err) {
					jq().toastmessage('showErrorToast', "AJAX error!" + err);
				})
	}
	//Abscond
	function abscond(id, obStatus) {
		var abscondData = {
			'id': id,
			'obStatus':obStatus
		};

		jq.getJSON('${ ui.actionLink("ipdapp", "patientInfo", "requestForDischarge") }', abscondData)
				.success(function (data) {
					localStorage.setItem('requestType',"abscond");
					location.reload();
				})
				.error(function (xhr, status, err) {
					jq().toastmessage('showErrorToast', "AJAX error!" + err);
				})
	}

	function selectTab(tabIdnt){
		jq('#tabs').tabs('select', tabIdnt);
	}

</script>

<style>

#person-detail{
	display: none;
}
.toast-item {
	background-color: #222;
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
.selecticon{
	float: right;
	vertical-align: middle;
	font-size: x-large;
}
.selectp{
	min-width: 450px;
	border-bottom: solid;
	border-bottom-width: 1px;
	padding-left: 5px;
	margin-top:20px;
}
.selectdiv{
	width: 450px;
	margin-top:10px;
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
#tabs {
	background: #f9f9f9 none repeat scroll 0 0;
	padding: 10px;
}
#tab-container{
	background: #f9f9f9 none repeat scroll 0 0;
	margin-top: 3px;
}
.ui-tabs .ui-tabs-panel {
	background: #fff none repeat scroll 0 0;
	padding-top: 0;
}
.col12{
	display: inline-block;
	float: left;
	width: 50%;
}
.col13{
	display: inline-block;
	float: left;
	width: auto;
}
.col15 {
	display: inline-block;
	float: left;
	max-width: 22%;
	min-width: 22%;
}
.col16 {
	display: inline-block;
	float: left;
	width: 78%;
}
.dashboard .action-section {
	background: white none repeat scroll 0 0;
	border: 1px solid #ddd;
	margin-top: 35px;
}
.dashboard .info-body label {
	display: inline-block;
	font-size: 90%;
	margin-bottom: 6px;
	margin-left: 5px;
	width: 115px;
}
.dashboard .info-body span {
	color: #000;
	font-size: 0.9em;
}
.zero-em{
	font-size: 0em!important;
}
.dashboard .info-header h3 {
	color: #f26522;
}
.daily-vitals label{
	float: left;
}
.daily-vitals span {
	display: block;
	overflow: hidden;
	padding-right:10px;
}
.daily-vitals input,
.daily-vitals select,
.daily-vitals textarea{
	width: 100%;
	resize: none;
}
.ui-widget-content a.right {
	cursor: pointer;
	font-size: 16px;
}
.ui-widget-content a.right:hover,
.ui-widget-content a.right:hover i {
	color: #3399ff;
	text-decoration: none;
}
form input:focus, form select:focus, form textarea:focus, form ul.select:focus, .form input:focus, .form select:focus, .form textarea:focus, .form ul.select:focus{
	outline: 0px none #007fff;
	box-shadow: 0 0 2px 0 #888;
}
.dashboard .action-section a:not(.button) {
	cursor: pointer;
}
#addDrugDialog{
	position: absolute;
	top: 0%;
	z-index: 3000;
	left: 25%;
	width: 60%;
	overflow: auto;
	height: 90%;
	min-height: 550px;
}
.hidden{
	display: none;
}
#dump-bed{
	width: 100%;
	display: grid;
	grid-template-columns: repeat(6, auto);
	gap: 7px;
	padding-bottom: 14px;
}
.bp-container{
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	padding: 2px;
}
.bp-span{
	padding: 3px;
}
.bp-container{
	padding: 3px;
	background-color: firebrick;
	color: white;
	cursor: pointer;
}
.bp-container[data-people="0"]{
	background-color: #34bf6e;
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
			Details
		</li>
	</ul>
</div>

<div class="patient-header new-patient-header">

    <div class="col16 dashboard">
    	<div class="info-section">
    		<div class="info-header">
    			<i class="icon-diagnosis"></i>
    			<h3>PATIENT DETAILS</h3>
    		</div>

    		<div class="info-body" style="min-height: 180px;">
    			<div class="col13">
    				<img src="${ui.resourceLink('ipdapp', 'images/patient-icon.jpg')}" style="border: 1px solid #eee; height: 190px; margin-right: 10px;" />
    			</div>

    			<div class="col13 last">
    			  <label>
              <i class="status active zero-em"></i>
              IPD Number :
            </label>
            <span><b>${ipdNumber}</b></span>
            <br />
    				<label>
    					<i class="status active zero-em"></i>
    					Patient :
    				</label>
    				<span>${patient.familyName}  ${patient.middleName?patient.middleName:''}</span>
    				<br/>

    				<label>
    					<i class="status active zero-em"></i>
    					Age :
    				</label>
    				<span>${patientInformation.age.substring(1, patientInformation.age.size())}</span>
    				<br/>

    				<label>
    					<i class="status active zero-em"></i>
    					Admitted On:
    				</label>
    				<span>${ui.formatDatePretty(patientInformation.admissionDate)}</span>
    				<br/>

    				<label>
    					<i class="status active zero-em"></i>
    					Ward :
    				</label>
    				<span>${patientInformation.admittedWard.name}</span>
    				<br/>

    				<label>
    					<i class="status active zero-em"></i>
    					Bed :
    				</label>
    				<span>00${patientInformation.bed}</span>
    				<br/>

    				<label>
    					<i class="status active zero-em"></i>
    					Admitted By:
    				</label>
    				<span>${patientInformation.user.person.names}</span>
    			</div>
    			<div class="clear"></div>
    		</div>
    	</div>
    </div>


    <div class="dashboard col15 last">
    	<div class="action-section">
    		<ul style="min-height: 200px;">
    			<h3>&nbsp; &nbsp;General Actions</h3>

    			<% if(patientInformation) { %>
            <% if (patientInformation.requestForDischargeStatus != 1 && patientInformation.absconded != 1) { %>
              <li>
                <i class="icon-edit"></i>
                <a onclick='requestForDischarge(${patientInformation.id},0)'>Request Discharge</a>
              </li>

              <li>
                <i class="icon-share"></i>
                <a onclick='abscond(${patientInformation.id},1)'>Patient Abscorded</a>
              </li>
            <% } %>


            <% if (patientInformation.absconded == 1) { %>
              <li>
                <i class="icon-user-times"></i>
                <a href="">Remove Patient</a>
              </li>
            <% } else if (patientInformation.requestForDischargeStatus == 1 && patientInformation.admittedWard) {%>
              <li>
                <i class="icon-edit"></i>
                <a href="dischargePatient.page?patientId=${patient.id}&ipdWard=${patientInformation.admittedWard.id}">Discharge Patient</a>
              </li>
            <% } %>

            <li>
              <i class="icon-print"></i>
              <a href="">Print Details</a>
            </li>

            <h3 style="margin-top: 15px;">&nbsp; &nbsp;Inpatient Actions</h3>
            <li>
              <i class="icon-user-md"></i>
              <a href="patientTreatment.page?patientId=${patient.id}">Update Treatment</a>
            </li>
          <%}%>

    		</ul>
    	</div>
    </div>


	<div class="clear"></div>
</div>

<div id="tab-container">
	<div id="tabs">
		<ul>
			<li class="tabs1"><a href="#tabs-1">Vitals</a></li>
			<li class="tabs3"><a href="#tabs-3">Clinical History</a></li>
			<li class="tabs4"><a href="#tabs-4">Lab Reports</a></li>
			<li class="tabs5"><a href="#tabs-5">Cardex</a></li>
			<li class="tabs6"><a href="#tabs-6">Nursing Care Plan</a></li>
			<li class="tabs7"><a href="#tabs-7">Charts</a></li>
			<li class="tabs8"><a href="#tabs-8">Drugs Administration</a></li>
			<li class="tabs9"><a href="#tabs-9">Transfer</a></li>
		</ul>

		<div id="tabs-1">
			${ui.includeFragment("ipdapp", "patientInfoDetails")}
		</div>

		<div id="tabs-3">
        	${ ui.includeFragment("ipdapp", "visitSummary", [patientId: patient.patientId]) }
        </div>

		<div id="tabs-4">
			${ ui.includeFragment("ipdapp", "investigations", [patientId: patient.patientId]) }
		</div>

		<div id="tabs-5">
            ${ ui.includeFragment("ipdapp", "nursingNotes", [patientId: patient.patientId]) }
        </div>

        <div id="tabs-6">
            ${ ui.includeFragment("ipdapp", "nursingCarePlan", [patientId: patient.patientId]) }
        </div>

        <div id="tabs-7">
            ${ ui.includeFragment("ipdapp", "charts", [patientId: patient.patientId]) }
        </div>

        <div id="tabs-8">
            ${ ui.includeFragment("ipdapp", "drugsAdministration", [patientId: patient.patientId]) }
        </div>

        <div id="tabs-9">
            ${ui.includeFragment("ipdapp", "patientInfoTransfer")}
       </div>


	</div>
</div>