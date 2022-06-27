package com.nilvera.xmlvalidationjavalin.controllers;

import com.nilvera.xmlvalidationjavalin.models.XmlValidationResultModel;
import com.nilvera.xmlvalidationjavalin.validators.UblTrValidator;
import io.javalin.http.Context;
import io.javalin.plugin.openapi.annotations.*;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ValidationController {
    private static ExecutorService executorService = Executors.newSingleThreadExecutor();

    @OpenApi(
            path = "/validate/schematron/ubltr_main",
            method = HttpMethod.POST,
            summary = "UBL-TR validation",
            description = "The path to validate UBL-TR files",
            fileUploads = @OpenApiFileUpload(name = "xmlFile", description = "The file that you want to validate", required = true),
            responses = {
                    @OpenApiResponse(status = "200", content = @OpenApiContent(from = XmlValidationResultModel.class)),
                    @OpenApiResponse(status = "500")
            }
    )
    public void validateUblTr(Context ctx) throws ExecutionException, InterruptedException {
        InputStream xmlStream = ctx.uploadedFile("xmlFile").getContent();
        XmlValidationResultModel model = getUblTrFuture(xmlStream).get();
        ctx.res.setCharacterEncoding(StandardCharsets.UTF_8.name());
        ctx.json(model);
    }


    private CompletableFuture<XmlValidationResultModel> getUblTrFuture(InputStream xmlStream) {
        CompletableFuture<XmlValidationResultModel> future = new CompletableFuture<>();
        executorService.execute(() -> {
            XmlValidationResultModel model = new UblTrValidator().validate(xmlStream);
            future.complete(model);
        });
        return future;
    }
}
