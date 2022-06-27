package com.nilvera.xmlvalidationjavalin.controllers;

import com.nilvera.xmlvalidationjavalin.models.HealthModel;
import io.javalin.http.Context;
import io.javalin.plugin.openapi.annotations.HttpMethod;
import io.javalin.plugin.openapi.annotations.OpenApi;
import io.javalin.plugin.openapi.annotations.OpenApiContent;
import io.javalin.plugin.openapi.annotations.OpenApiResponse;

public class HealthController {
    @OpenApi(
            path = "/health",
            method = HttpMethod.GET,
            summary = "Server status",
            description = "Returns \"UP\" when server is ready to response",
            responses = {
                    @OpenApiResponse(status = "200", content = @OpenApiContent(from = HealthModel.class))
            }
    )
    public void index(Context ctx) {
        ctx.json(new HealthModel());
    }
}
