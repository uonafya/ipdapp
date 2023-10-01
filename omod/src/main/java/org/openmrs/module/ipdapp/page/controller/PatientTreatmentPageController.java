package org.openmrs.module.ipdapp.page.controller;

import org.openmrs.Concept;
import org.openmrs.ConceptSet;
import org.openmrs.Patient;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.ipdapp.utils.IpdConstants;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.apache.commons.lang.StringEscapeUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.ConceptSet;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.BillableService;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.hospitalcore.model.Option;
import org.openmrs.module.hospitalcore.model.Referral;
import org.openmrs.module.hospitalcore.model.ReferralReasons;
import org.openmrs.module.patientdashboardapp.model.*;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 *
 */
@AppPage(IpdConstants.APP_IPD_APP)
public class PatientTreatmentPageController {
    public void get(@RequestParam("patientId") Patient patient,
                    PageModel model, UiUtils ui) {
        IpdService ipdService = Context.getService(IpdService.class);
        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(patient.getPatientId());
        model.addAttribute("patient", patient);
        model.addAttribute("patientInformation", patientInformation);
        PersonAttributeType paymentCategoryPaymentAttribute = Context.getPersonService().getPersonAttributeTypeByUuid("09cd268a-f0f5-11ea-99a8-b3467ddbf779");
        PersonAttributeType paymentCategorySubTypePaymentAttribute = Context.getPersonService()
                .getPersonAttributeTypeByUuid("972a32aa-6159-11eb-bc2d-9785fed39154");
        //fetch drug frequencies
        InventoryCommonService inventoryCommonService = Context.getService(InventoryCommonService.class);
        List<Concept> drugFrequencyConcept = inventoryCommonService.getDrugFrequency();
        model.addAttribute("drugFrequencyList", drugFrequencyConcept);
        model.addAttribute("category", patient.getAttribute(paymentCategoryPaymentAttribute));
        model.addAttribute("subCategory", patient.getAttribute(paymentCategorySubTypePaymentAttribute));
        model.addAttribute("dosageUnits", getDrugUnit(ui));

        model.addAttribute("outcomeOptions", SimpleObject.fromCollection(Outcome.getAvailableOutcomes(), ui, "label", "id"));
        model.addAttribute("listOfWards", SimpleObject.fromCollection(Outcome.getInpatientWards(), ui, "label", "id"));
        model.addAttribute("internalReferralSources", SimpleObject.fromCollection(Referral.getInternalReferralOptions(), ui, "label", "id"));
        model.addAttribute("externalReferralSources", SimpleObject.fromCollection(Referral.getExternalReferralOptions(), ui, "label", "id"));
        model.addAttribute("referralReasonsSources", SimpleObject.fromCollection(ReferralReasons.getReferralReasonsOptions(), ui, "label", "id"));

        Note note = new Note();
        note.setPatientId(patient.getPatientId());
        note.setDiagnoses(new ArrayList<>());
        note.setSigns(new ArrayList<>());
        note.setPhysicalExamination("");
        note.setIllnessHistory("");
        note.setOnSetDate("");
        note.setInvestigations(new ArrayList<>());
        note.setInvestigationNotes("");


        model.addAttribute("note", StringEscapeUtils.escapeJavaScript(SimpleObject.fromObject(note, ui, "signs.id", "signs.label", "diagnoses.id", "diagnoses.label",
                "investigations", "investigationNotes", "procedures", "patientId", "queueId","specify",
                "opdId", "opdLogId", "admitted","facility", "onSetDate", "illnessHistory","referralComments","physicalExamination", "otherInstructions").toJson()));


    }


    public List<SimpleObject> getQualifiers(@RequestParam("signId") Integer signId, UiUtils ui) {
        Concept signConcept = Context.getConceptService().getConcept(signId);
        List<Qualifier> qualifiers = new ArrayList<Qualifier>();
        for (ConceptAnswer conceptAnswer : signConcept.getAnswers()) {
            qualifiers.add(new Qualifier(conceptAnswer.getAnswerConcept()));
        }
        return SimpleObject.fromCollection(qualifiers, ui, "id", "label", "uuid", "options.id", "options.label", "options.uuid");
    }

    public List<SimpleObject> getSymptoms(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> symptoms = Context.getService(PatientDashboardService.class).searchSymptom(name);

        return SimpleObject.fromCollection(symptoms, ui, "id", "name", "uuid");
    }

    public static String PROPERTY_DRUGUNIT = "patientdashboard.dosingUnitConceptId";

    public List<SimpleObject> getDiagnosis(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> diagnosis = Context.getService(PatientDashboardService.class).searchDiagnosis(name);

        return SimpleObject.fromCollection(diagnosis, ui, "id", "name", "uuid");
    }
    public List<SimpleObject> getProcedures(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> procedures = Context.getService(PatientDashboardService.class).searchProcedure(name);
        List<Procedure> proceduresPriority = new ArrayList<Procedure>();
        for(Concept myConcept: procedures){
            proceduresPriority.add(new Procedure(myConcept));
        }

        return SimpleObject.fromCollection(proceduresPriority, ui, "id", "label", "schedulable", "uuid");
    }

    public List<SimpleObject> getInvestigations(@RequestParam(value="q") String name,UiUtils ui)
    {
        BillingService investigations = Context.getService(BillingService.class);
        List<BillableService> investigation = investigations.searchService(name);
        return SimpleObject.fromCollection(investigation, ui, "conceptId", "name");
    }
    public List<SimpleObject> getDrugs(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<InventoryDrug> drugs = Context.getService(PatientDashboardService.class).findDrug(name);
        return SimpleObject.fromCollection(drugs, ui, "id", "name");
    }
    public List<SimpleObject> getFormulationByDrugName(@RequestParam(value="drugName") String drugName,UiUtils ui)
    {

        InventoryCommonService inventoryCommonService = (InventoryCommonService) Context.getService(InventoryCommonService.class);
        InventoryDrug drug = inventoryCommonService.getDrugByName(drugName);

        List<SimpleObject> formulationsList = null;

        if(drug != null){
            List<InventoryDrugFormulation> formulations = new ArrayList<InventoryDrugFormulation>(drug.getFormulations());
            formulationsList = SimpleObject.fromCollection(formulations, ui, "id", "name","dozage");
        }

        return formulationsList;
    }

    public List<SimpleObject> getFrequencies(UiUtils uiUtils){
        InventoryCommonService inventoryCommonService = Context
                .getService(InventoryCommonService.class);
        List<Concept> drugFrequencyConcept = inventoryCommonService
                .getDrugFrequency();
        if(drugFrequencyConcept != null){
            return SimpleObject.fromCollection(drugFrequencyConcept,uiUtils, "id", "name", "uuid");
        }
        else{
            return null;
        }
    }

    public List<SimpleObject> getDrugUnit(UiUtils uiUtils){
        Concept drugUnit = Context.getConceptService().getConcept(Context.getAdministrationService().getGlobalProperty(PROPERTY_DRUGUNIT));
        Collection<ConceptSet> unit = drugUnit.getConceptSets();
        List<Option> drugUnitOptions = new ArrayList<Option>();
        for (ConceptSet conceptSet: unit) {
            drugUnitOptions.add(new Option(conceptSet.getConcept()));
        }
        return SimpleObject.fromCollection(drugUnitOptions,uiUtils,"id","label", "uuid") ;
    }
}
