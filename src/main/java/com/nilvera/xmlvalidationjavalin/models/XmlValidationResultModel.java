package com.nilvera.xmlvalidationjavalin.models;

import java.util.List;

public class XmlValidationResultModel {
    private final boolean isValid;
    private final List<String> errors;

    public XmlValidationResultModel(boolean isValid, List<String> errors) {
        this.isValid = isValid;
        this.errors = errors;
    }

    public XmlValidationResultModel(boolean isValid) {
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
