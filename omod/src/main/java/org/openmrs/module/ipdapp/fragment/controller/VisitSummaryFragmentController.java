package org.openmrs.module.ipdapp.fragment.controller;

import org.openmrs.*;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.OpdDrugOrder;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.module.ipdapp.model.VisitDetail;
import org.openmrs.module.ipdapp.model.VisitSummary;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.ui.framework.BasicUiUtils;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VisitSummaryFragmentController {



    public void controller(
            FragmentConfiguration config,
            FragmentModel model,
            UiUtils ui
    ) {
        config.require("patientId");
        Integer patientId = Integer.parseInt(config.get("patientId").toString());
        PatientDashboardService dashboardService = Context.getService(PatientDashboardService.class);
        Location location = Context.getService(KenyaEmrService.class).getDefaultLocation();

        IpdService ipdService = Context.getService(IpdService.class);
        IpdPatientAdmitted admitted = ipdService.getAdmittedByPatientId(patientId);
        Patient patient = Context.getPatientService().getPatient(patientId);

        List<Encounter> encounters = dashboardService.getEncounter(patient, location, admitted.getPatientAdmissionLog().getIpdEncounter().getEncounterType(), null);

        List<VisitSummary> visitSummaries = new ArrayList<VisitSummary>();

        int i = 0;

        for (Encounter enc : encounters) {
            VisitSummary visitSummary = new VisitSummary();
            visitSummary.setVisitDate(enc.getDateCreated());
            visitSummary.setEncounterId(enc.getEncounterId());
            String outcomeConceptName = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_VISIT_OUTCOME);
            Concept outcomeConcept = Context.getConceptService().getConcept(outcomeConceptName);
            for (Obs obs : enc.getAllObs()) {
                if (obs.getConcept().equals(outcomeConcept)) {
                    visitSummary.setOutcome(obs.getValueText());
                }
            }

//            VisitDetail visitDetail = VisitDetail.create(enc);
//
//            SimpleObject detail = SimpleObject.fromObject(visitDetail, ui, "history","diagnosis", "symptoms", "procedures", "investigations","physicalExamination","visitOutcome","internalReferral","externalReferral");
//
//            List<OpdDrugOrder> opdDrugs = Context.getService(PatientDashboardService.class).getOpdDrugOrder(enc);
//            List<SimpleObject> drugs = SimpleObject.fromCollection(opdDrugs, ui, "inventoryDrug.name",
//                    "inventoryDrug.unit.name", "inventoryDrugFormulation.name", "inventoryDrugFormulation.dozage","dosage", "dosageUnit.name");
//
//            visitSummary.setVisitDetails(SimpleObject.create("notes", detail, "drugs", drugs));

            visitSummaries.add(visitSummary);

            i++;

            if (i >=20){
                break;
            }
        }

        model.addAttribute("patient", patient);
        model.addAttribute("visitSummaries", visitSummaries);
    }

    public SimpleObject getVisitSummaryDetails(
            @RequestParam("encounterId") Integer encounterId,
            UiUtils ui
    ) {
        Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
        VisitDetail visitDetail = VisitDetail.create(encounter);

        SimpleObject detail = SimpleObject.fromObject(visitDetail, ui, "history","diagnosis", "symptoms", "procedures", "investigations","physicalExamination","visitOutcome","internalReferral","externalReferral");
        List<OpdDrugOrder> opdDrugs = Context.getService(PatientDashboardService.class).getOpdDrugOrder(encounter);
        List<SimpleObject> drugs = SimpleObject.fromCollection(opdDrugs, ui, "inventoryDrug.name",
                "inventoryDrug.unit.name", "inventoryDrugFormulation.name", "inventoryDrugFormulation.dozage","dosage", "dosageUnit.name");

        return SimpleObject.create("notes", detail, "drugs", drugs);
    }


}