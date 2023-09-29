<script>
	var dischargedPatients;
	var dischargedPatientsTableObject;
	var dischargedPatientsResultsData = [];

	var getDischargedPatients = function(){
		dischargedPatientsTableObject.find('td.dataTables_empty').html('<span><img class="search-spinner" src="'+ui.resourceLink('uicommons', 'images/spinner.gif')+'" /></span>');
		var requestData = {
			ipdWard:		'${ipdWard.id}',
			fromDate:		jq('#outsFrom-field').val(),
			toDate:			jq('#outsDate-field').val()
		}

		jq.getJSON('${ ui.actionLink("ipdapp", "PatientAdmission", "listDischargedIpdPatients") }', requestData)
			.success(function (data) {
				updateDischargedPatientsResults(data);
			}).error(function (xhr, status, err) {
				updateDischargedPatientsResults([]);
			}
		);
	};

	var updateDischargedPatientsResults = function(results){
		dischargedPatientsResultsData = results || [];
		var dataRows = [];
		_.each(dischargedPatientsResultsData, function(result){
			var icons = '<a class="button task dropdown" href="patientInfo.page?search=' + result.patientIdentifier + '&ipdWard='+ result.dischargedWard +'" style="position: static; padding: 5px 12px; float: none; margin: 0px 3px;"><i class="icon-cog"></i>&nbsp; Details &nbsp;<i class="icon-location"></i></a>';
			var gender = result.gender;
			if (gender == "M"){
				gender = 'Male';
			}else{
				gender = 'Female';
			}
			dataRows.push([0, moment(result.admissionDate, "DD.MMM.YYYY").format('DD/MM/YYYY'), result.patientIdentifier, result.patientName, gender, icons]);
		});

		dischargedPatients.api().clear();

		if(dataRows.length > 0) {
			dischargedPatients.fnAddData(dataRows);
		}

		refreshInTable(dischargedPatientsResultsData, dischargedPatients);
	};

	jq(function () {
		dischargedPatientsTableObject = jq("#dischargedList");

		dischargedPatients = dischargedPatientsTableObject.dataTable({
			autoWidth: false,
			bFilter: true,
			bJQueryUI: true,
			bLengthChange: false,
			iDisplayLength: 15,
			sPaginationType: "full_numbers",
			bSort: false,
			sDom: 't<"fg-toolbar ui-toolbar ui-corner-bl ui-corner-br ui-helper-clearfix datatables-info-and-pg"ip>',
			oLanguage: {
				"sInfo": "Transactions",
				"sInfoEmpty": " ",
				"sZeroRecords": "No Patient's Found in Queue",
				"sInfoFiltered": "(Showing _TOTAL_ of _MAX_ Transactions)",
				"oPaginate": {
					"sFirst": "First",
					"sPrevious": "Previous",
					"sNext": "Next",
					"sLast": "Last"
				}
			},

			fnDrawCallback : function(oSettings){
				if(isTableEmpty(dischargedPatientsResultsData, dischargedPatients)){
					return;
				}
			},

			fnRowCallback : function (nRow, aData, index){
				return nRow;
			}
		});

		dischargedPatients.on( 'order.dt search.dt', function () {
			dischargedPatients.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
				cell.innerHTML = i+1;
			} );
		}).api().draw();

		jq('#outsNames').on('keyup', function () {
			dischargedPatients.api().search( this.value ).draw();
		});

        jq(".stockoutParams").on('change', function () {
            getDischargedPatients();
        });

		jq('#queueList').on('click', 'a.remove-patient', function(){
			var requestData = {
				admissionId: jq(this).data('idnt'),
				action: jq(this).data('action')
			}

			jq.post('${ ui.actionLink("ipdapp", "PatientAdmission", "removeOrNoBed") }', requestData)
				.success(function (data) {
					jq().toastmessage('showErrorToast', "Successfully Updated Queue Patient Information");
					getDischargedPatients();
				}).error(function (xhr, status, err) {
					jq().toastmessage('showErrorToast', "AJAX error!" + err);
				}
			);
		});

		getDischargedPatients();
	});
</script>

<table cellpadding="5" cellspacing="0" width="100%" id="dischargedList">
	<thead>
		<tr align="center">
			<th style="width: 5px">#</th>
			<th style="width: 100px">DATE</th>
			<th>IDENTIFIER</th>
			<th>NAMES</th>
			<th>GENDER</th>
			<th style="width: 105px">ACTION</th>
		</tr>
	</thead>
	<tbody>
	</tbody>
</table>