package com.nilvera.xmlvalidationjavalin.controllers;

import io.javalin.http.Context;
import io.javalin.plugin.openapi.annotations.OpenApi;

public class DefaultController {
    @OpenApi(ignore = true)
    public void index(Context ctx) {
        ctx.redirect("/swagger");
    }
}
