package org.openmrs.module.ipdapp.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.DrugAdministration;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.IpdPatientVitalStatistics;
import org.openmrs.module.hospitalcore.model.OpdDrugOrder;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class DrugsAdministrationFragmentController {

    public void controller(
            FragmentConfiguration config,
            FragmentModel model,
            UiUtils ui
    ){
        config.require("patientId");
        Integer patientId = Integer.parseInt(config.get("patientId").toString());

        IpdService ipdService = Context.getService(IpdService.class);
        PatientDashboardService patientDashboardService = Context.getService(PatientDashboardService.class);
        Patient patient = Context.getPatientService().getPatient(patientId);
        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(patient.getPatientId());

        List<OpdDrugOrder> opdDrugOrders = patientDashboardService.getOpdDrugOrder(patientInformation.getPatientAdmissionLog().getIpdEncounter());
        List<SimpleObject> drugs = SimpleObject.fromCollection(
                opdDrugOrders,
                ui,
                "opdDrugOrderId",
                "inventoryDrug.name",
                "inventoryDrug.unit.name",
                "inventoryDrugFormulation.name",
                "inventoryDrugFormulation.dozage",
                "dosage",
                "dosageUnit.name"
        );

        model.addAttribute("drugs", drugs);
        model.addAttribute("patient", patient);
    }

    public SimpleObject getDrugAdministrationDetails(
            @RequestParam("drugOrderId") Integer drugOrderId
    ) {

        HospitalCoreService hospitalCoreService = Context.getService(HospitalCoreService.class);

        List<DrugAdministration> drugAdministrations = hospitalCoreService.retrieveDrugAdministrations(drugOrderId);

        return SimpleObject.create("drugAdministrations", drugAdministrations);
    }

    public void saveDrugAdministration(
            @RequestParam(value ="drugAdministrationId", required = false) Integer drugAdministrationId,
            @RequestParam(value ="drugOrderId", required = false) Integer drugOrderId,
            @RequestParam(value ="quantity", required = false) Double quantity,
            @RequestParam(value ="remarks", required = false) String remarks
    ) {

        HospitalCoreService hospitalCoreService = Context.getService(HospitalCoreService.class);

        User user = Context.getAuthenticatedUser();
        Date date = new Date();

        DrugAdministration drugAdministration = new DrugAdministration();
        drugAdministration.setDrugAdministrationId(drugAdministrationId);
        drugAdministration.setDrugOrderId(drugOrderId);
        drugAdministration.setDrugAdministrationDate(date);
        drugAdministration.setQuantity(quantity);
        drugAdministration.setAmount(1d);
        drugAdministration.setChangedBy(user);
        drugAdministration.setDateModified(date);
        drugAdministration.setStatus(remarks);

        if(drugAdministrationId > 0){
            hospitalCoreService.updateDrugAdministration(drugAdministration);
        }else{
            drugAdministration.setCreatedBy(user);
            drugAdministration.setCreatedOn(date);

            hospitalCoreService.createDrugAdministration(drugAdministration);
        }



    }
}
