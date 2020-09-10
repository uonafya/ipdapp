package org.openmrs.module.ipdapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.*;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.ipdapp.WardOverview;
import org.openmrs.module.ipdapp.utils.IpdConstants;
import org.openmrs.ui.framework.page.PageModel;

import java.util.*;

/**
 * Created by ngarivictor on 1/12/2016.
 */
public class ChooseIpdWardPageController {
    public void get(PageModel model) {
        Concept ipdConcept = Context.getConceptService().getConceptByName(Context.getAdministrationService().getGlobalProperty(IpdConstants.PROPERTY_IPDWARD));
        List<ConceptAnswer> ipdWardsList = (ipdConcept != null ? new ArrayList<ConceptAnswer>(ipdConcept.getAnswers()) : null);
        List<WardOverview> wardOverviewList = new ArrayList<WardOverview>();
        IpdService ipdService = Context.getService(IpdService.class);
        if (CollectionUtils.isNotEmpty(ipdWardsList)) {
            for (ConceptAnswer ward : ipdWardsList) {
                Integer patientCount = ipdService.searchIpdPatientAdmitted(null, null, null, null, ward.getAnswerConcept().getConceptId().toString(), "").size();
                Integer bedCount = ipdService.getWardBedStrengthByWardId(ward.getAnswerConcept().getConceptId()).getBedStrength();
                WardOverview wardOverview = new WardOverview(bedCount, patientCount, ward.getAnswerConcept());
                wardOverviewList.add(wardOverview);
            }
        }
        model.addAttribute("wardOverviewList", wardOverviewList);
    }
    public void creatConceptQuestionAndAnswer(ConceptService conceptService,  User user ,String conceptParent, String...conceptChild) {
        // System.out.println("========= insertExternalHospitalConcepts =========");
        Concept concept = conceptService.getConcept(conceptParent);
        if(concept == null){
            insertConcept(conceptService, "Coded", "Question" , conceptParent);
        }
        if (concept != null) {

            for (String hn : conceptChild) {
                insertHospital(conceptService, hn);
            }
            addConceptAnswers(concept, conceptChild, user);
        }
    }
    private void addConceptAnswers(Concept concept, String[] answerNames,
                                   User creator) {
        Set<Integer> currentAnswerIds = new HashSet<Integer>();
        for (ConceptAnswer answer : concept.getAnswers()) {
            currentAnswerIds.add(answer.getAnswerConcept().getConceptId());
        }
        boolean changed = false;
        for (String answerName : answerNames) {
            Concept answer = Context.getConceptService().getConcept(answerName);
            if (!currentAnswerIds.contains(answer.getConceptId())) {
                changed = true;
                ConceptAnswer conceptAnswer = new ConceptAnswer(answer);
                conceptAnswer.setCreator(creator);
                concept.addAnswer(conceptAnswer);
            }
        }
        if (changed) {
            Context.getConceptService().saveConcept(concept);
        }
    }
    private Concept insertHospital(ConceptService conceptService,
                                   String hospitalName) {
        try {
            ConceptDatatype datatype = Context.getConceptService()
                    .getConceptDatatypeByName("N/A");
            ConceptClass conceptClass = conceptService
                    .getConceptClassByName("Misc");
            Concept con = conceptService.getConceptByName(hospitalName);
            // System.out.println(con);
            if (con == null) {
                con = new Concept();
                ConceptName name = new ConceptName(hospitalName,
                        Context.getLocale());
                con.addName(name);
                con.setDatatype(datatype);
                con.setConceptClass(conceptClass);
                return conceptService.saveConcept(con);
            }
            return con;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    private Concept insertConcept(ConceptService conceptService,
                                  String dataTypeName, String conceptClassName, String concept) {
        try {
            ConceptDatatype datatype = Context.getConceptService()
                    .getConceptDatatypeByName(dataTypeName);
            ConceptClass conceptClass = conceptService
                    .getConceptClassByName(conceptClassName);
            Concept con = conceptService.getConcept(concept);
            // System.out.println(con);
            if (con == null) {
                con = new Concept();
                ConceptName name = new ConceptName(concept,
                        Context.getLocale());
                con.addName(name);
                con.setDatatype(datatype);
                con.setConceptClass(conceptClass);
                return conceptService.saveConcept(con);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
