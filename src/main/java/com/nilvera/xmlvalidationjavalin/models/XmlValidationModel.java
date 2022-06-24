package com.nilvera.xmlvalidationjavalin.models;

import java.util.List;

public class XmlValidationModel {
    private final boolean isValid;
    private final List<String> errors;

    public XmlValidationModel(boolean isValid, List<String> errors) {
        this.isValid = isValid;
        this.errors = errors;
    }

    public XmlValidationModel(boolean isValid) {
        this.isValid = isValid;
        errors = null;
    }

    public boolean getIsValid() {
        return isValid;
    }

    public List<String> getErrors() {
        return errors;
    }
}
