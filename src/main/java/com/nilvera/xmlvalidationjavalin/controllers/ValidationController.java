package com.nilvera.xmlvalidationjavalin.controllers;

import com.nilvera.xmlvalidationjavalin.models.XmlValidationModel;
import com.nilvera.xmlvalidationjavalin.validators.DespatchAdviceValidator;
import com.nilvera.xmlvalidationjavalin.validators.InvoiceValidator;
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
            description = "The endpoint to validate UBL-TR files",
            fileUploads = @OpenApiFileUpload(name = "Source", description = "The file that you want to validate", required = true),
            responses = {
                    @OpenApiResponse(status = "200", description = "Returns 200 if everything is OK", content = @OpenApiContent(from = XmlValidationModel.class)),
                    @OpenApiResponse(status = "500", description = "Server error", content = @OpenApiContent(from = XmlValidationModel.class))
            }
    )
    public void validateUblTrSchematron(Context ctx) throws ExecutionException, InterruptedException {
        InputStream xmlStream = ctx.uploadedFile("Source").getContent();
        XmlValidationModel model = getUblTrSchematronFuture(xmlStream).get();
        ctx.res.setCharacterEncoding(StandardCharsets.UTF_8.name());

        if (model.getErrorMessage() != null) {
            ctx.status(500).json(model);
            return;
        }

        ctx.status(200).json(model);
    }

    @OpenApi(
            path = "/validate/schema/invoice",
            method = HttpMethod.POST,
            summary = "Invoice validation",
            description = "The endpoint to validate invoice files",
            fileUploads = @OpenApiFileUpload(name = "Source", description = "The file that you want to validate", required = true),
            responses = {
                    @OpenApiResponse(status = "200", description = "Returns 200 if everything is OK", content = @OpenApiContent(from = XmlValidationModel.class)),
                    @OpenApiResponse(status = "500", description = "Server error", content = @OpenApiContent(from = XmlValidationModel.class))
            }
    )
    public void validateInvoiceSchema(Context ctx) throws ExecutionException, InterruptedException {
        InputStream xmlStream = ctx.uploadedFile("Source").getContent();
        XmlValidationModel model = getInvoiceSchemaFuture(xmlStream).get();
        ctx.res.setCharacterEncoding(StandardCharsets.UTF_8.name());

        if (model.getErrorMessage() != null) {
            ctx.status(500).json(model);
            return;
        }

        ctx.status(200).json(model);
    }
    @OpenApi(
            path = "/validate/schema/despatch_advice",
            method = HttpMethod.POST,
            summary = "Despatch advice validation",
            description = "The enpoint to validate despatch files",
            fileUploads = @OpenApiFileUpload(name = "Source", description = "The file that you want to validate", required = true),
            responses = {
                    @OpenApiResponse(status = "200", description = "Returns 200 if everything is OK", content = @OpenApiContent(from = XmlValidationModel.class)),
                    @OpenApiResponse(status = "500", description = "Server error", content = @OpenApiContent(from = XmlValidationModel.class))
            }
    )
    public void validateDespatchSchema(Context ctx) throws ExecutionException, InterruptedException {
        InputStream xmlStream = ctx.uploadedFile("Source").getContent();
        XmlValidationModel model = getDespatchSchemaFuture(xmlStream).get();
        ctx.res.setCharacterEncoding(StandardCharsets.UTF_8.name());

        if (model.getErrorMessage() != null) {
            ctx.status(500).json(model);
            return;
        }

        ctx.status(200).json(model);
    }

    private CompletableFuture<XmlValidationModel> getUblTrSchematronFuture(InputStream xmlStream) {
        CompletableFuture<XmlValidationModel> future = new CompletableFuture<>();
        executorService.execute(() -> {
            XmlValidationModel model = new UblTrValidator().validate(xmlStream);
            future.complete(model);
        });
        return future;
    }

    private CompletableFuture<XmlValidationModel> getInvoiceSchemaFuture(InputStream xmlStream) {
        CompletableFuture<XmlValidationModel> future = new CompletableFuture<>();
        executorService.execute(() -> {
            XmlValidationModel model = new InvoiceValidator().validate(xmlStream);
            future.complete(model);
        });
        return future;
    }

    private CompletableFuture<XmlValidationModel> getDespatchSchemaFuture(InputStream xmlStream) {
        CompletableFuture<XmlValidationModel> future = new CompletableFuture<>();
        executorService.execute(() -> {
            XmlValidationModel model = new DespatchAdviceValidator().validate(xmlStream);
            future.complete(model);
        });
        return future;
    }
}
