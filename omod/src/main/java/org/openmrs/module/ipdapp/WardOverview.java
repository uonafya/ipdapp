package org.openmrs.module.ipdapp;

import org.openmrs.Concept;

/**
 * Created by daugm on 9/16/2016.
 */
public class WardOverview {
    private int bedCount;
    private int patientCount;
    private Concept wardConcept;

    public WardOverview(int bedCount, int patientCount, Concept wardConcept) {
        this.bedCount = bedCount;
        this.patientCount = patientCount;
        this.wardConcept = wardConcept;
    }

    public int getBedCount() {
        return bedCount;
    }

    public void setBedCount(int bedCount) {
        this.bedCount = bedCount;
    }

    public int getPatientCount() {
        return patientCount;
    }

    public void setPatientCount(int patientCount) {
        this.patientCount = patientCount;
    }

    public Concept getWardConcept() {
        return wardConcept;
    }

    public void setWardConcept(Concept wardConcept) {
        this.wardConcept = wardConcept;
    }
}
