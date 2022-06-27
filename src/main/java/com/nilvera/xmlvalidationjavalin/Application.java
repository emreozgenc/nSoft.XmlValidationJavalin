package com.nilvera.xmlvalidationjavalin;

import com.nilvera.xmlvalidationjavalin.controllers.DefaultController;
import com.nilvera.xmlvalidationjavalin.controllers.HealthController;
import com.nilvera.xmlvalidationjavalin.controllers.ValidationController;
import io.javalin.Javalin;
import io.javalin.plugin.openapi.OpenApiOptions;
import io.javalin.plugin.openapi.OpenApiPlugin;
import io.javalin.plugin.openapi.ui.SwaggerOptions;
import io.swagger.v3.oas.models.info.Info;

public class Application {
    private static final int PORT = 8181;

    public static void main(String[] args) {

        Javalin app = Javalin.create(config -> {
            config.registerPlugin(new OpenApiPlugin(getOpenApiOptions()));
        }).start(PORT);

        HealthController healthController = new HealthController();
        ValidationController validationController = new ValidationController();
        DefaultController defaultController = new DefaultController();

        app.get("/", defaultController::index);

        app.get("/health", healthController::index);

        app.post("/validate/schematron/ubltr_main", validationController::validateUblTrSchematron);
        app.post("/validate/schema/invoice", validationController::validateInvoiceSchema);

        app.exception(Exception.class, (e, ctx) -> {
            ctx.status(500).result(e.getMessage());
        });

    }

    private static OpenApiOptions getOpenApiOptions() {
        return new OpenApiOptions(new Info()
                .title("Nilvera XML Validation")
                .version("1.0")
                .description("Nilvera XML Validation API")
        ).path("/swagger-docs").swagger(new SwaggerOptions("/swagger").title("Nilvera Software App"));
    }
}
