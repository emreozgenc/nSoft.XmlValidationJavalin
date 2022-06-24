package com.nilvera.xmlvalidationjavalin;

import io.javalin.Javalin;

public class Application {
    public static void main(String[] args) {
        Javalin app = Javalin.start(7000);
        app.get("/", ctx -> ctx.result("Hello World"));
    }
}
