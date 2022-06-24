package com.nilvera.xmlvalidationjavalin;

import com.nilvera.xmlvalidationjavalin.constants.Path;
import com.nilvera.xmlvalidationjavalin.models.XmlValidationModel;
import com.nilvera.xmlvalidationjavalin.validators.UblTrValidator;
import io.javalin.Javalin;

public class Application {
    private static final int PORT = 8181;
    public static void main(String[] args) {
        Javalin app = Javalin.start(PORT);

        app.post(Path.UBL_TR, ctx -> {
            XmlValidationModel model = new UblTrValidator().validate(ctx.uploadedFile("xmlFile").getContent());
            ctx.json(model);
        });
    }
}
