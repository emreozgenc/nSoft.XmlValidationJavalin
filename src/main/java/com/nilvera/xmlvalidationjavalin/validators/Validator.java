package com.nilvera.xmlvalidationjavalin.validators;

import com.nilvera.xmlvalidationjavalin.models.XmlValidationModel;

import java.io.InputStream;

public interface Validator {
    XmlValidationModel validate(InputStream inputStream) throws Exception;
}
