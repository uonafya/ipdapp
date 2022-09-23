package org.openmrs.module.ipdapp.page.controller;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Patient;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.ipdapp.utils.IpdConstants;
import org.openmrs.module.kenyaui.annotation.AppPage;
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
                    PageModel model) {
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
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
        model.addAttribute("dosageUnits", getDrugUnit());
        System.out.println("The list of concepts are >>"+getDrugUnit());

    }

    public List<Concept> getDrugUnit(){
        Concept drugUnit = Context.getConceptService().getConceptByUuid("162384AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        Collection<ConceptAnswer> unit = drugUnit.getAnswers();
        List<Concept> drugUnitOptions = new ArrayList<Concept>();
        for (ConceptAnswer conceptUnit: unit) {
            drugUnitOptions.add(conceptUnit.getConcept());
        }
        return drugUnitOptions ;
    }
}
