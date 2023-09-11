package org.openmrs.module.ipdapp.model;

import java.util.Date;

public class NursingNote {
    private Integer encounterId;
    private String details;
    private Date date;

    public NursingNote() {
    }

    public NursingNote(Integer encounterId, String details, Date date) {
        this.encounterId = encounterId;
        this.details = details;
        this.date = date;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public Integer getEncounterId() {
        return encounterId;
    }

    public void setEncounterId(Integer encounterId) {
        this.encounterId = encounterId;
    }
}
