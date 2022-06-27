package com.nilvera.xmlvalidationjavalin.validators;

import com.nilvera.xmlvalidationjavalin.models.XmlValidationResultModel;

import java.io.InputStream;

public interface Validator {
    XmlValidationResultModel validate(InputStream inputStream) throws Exception;
}
