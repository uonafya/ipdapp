package org.openmrs.module.ipdapp.model;

import org.openmrs.ui.framework.SimpleObject;

import java.util.Date;


public class VisitSummary {

    private Date visitDate;
    private String outcome;
    private Integer encounterId;
    private SimpleObject visitDetails;

    public Date getVisitDate() {
        return visitDate;
    }

    public void setVisitDate(Date visitDate) {
        this.visitDate = visitDate;
    }

    public String getOutcome() {
        return outcome;
    }

    public void setOutcome(String outcome) {
        this.outcome = outcome;
    }

    public Integer getEncounterId() {
        return encounterId;
    }

    public void setEncounterId(Integer encounterId) {
        this.encounterId = encounterId;
    }

    public SimpleObject getVisitDetails() {
        return visitDetails;
    }

    public void setVisitDetails(SimpleObject visitDetails) {
        this.visitDetails = visitDetails;
    }
}