package com.sequarius.generator.common;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 05/02/2020
 */
@Slf4j
public class FreeMarkerSupport {

    private Configuration configuration;
    private GenerateSpec generateSpec;


    public FreeMarkerSupport(GenerateSpec generateSpec) {
        this.generateSpec = generateSpec;
        configuration = new Configuration(Configuration.VERSION_2_3_22);
        configuration.setClassForTemplateLoading(FreeMarkerSupport.class, "/template");
        configuration.setDefaultEncoding("UTF-8");
        configuration.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
    }

    public Template getTemplate(String templateName) throws IOException {
        GenerateSpec generateSpec = new GenerateSpec();
        return configuration.getTemplate(templateName);
    }

    public void generateRequestDTO() throws IOException {
        Template temp = getTemplate("EntityRequestTemplate.ftl");
        writeToFile(temp, generateSpec.getDomainPackageName(), generateSpec.getEntityName() + "RequestDTO.java");
    }

    public void generateResponseDTO() throws IOException {
        Template temp = getTemplate("EntityResponseTemplate.ftl");
        writeToFile(temp, generateSpec.getDomainPackageName(), generateSpec.getEntityName() + "ResponseDTO.java");
    }

    public void generateService() throws IOException {
        Template temp = getTemplate("ServiceTemplate.ftl");
        writeToFile(temp, generateSpec.getServicePackageName(), generateSpec.getEntityName() + "Service.java");
        Template tempImpl = getTemplate("ServiceImplTemplate.ftl");
        writeToFile(tempImpl, generateSpec.getServicePackageName() + "/impl", generateSpec.getEntityName() + "ServiceImpl.java");
    }

    public void generateController() throws IOException {
        Template temp = getTemplate("ControllerTemplate.ftl");
        writeToFile(temp, generateSpec.getControllerPackageName(), generateSpec.getEntityName() + "Controller.java");
    }


    public String getFileName(String subPackageName, String fileName) {
        String outputFileName = generateSpec.getProjectRoot() + "/src/main/java/" +
                generateSpec.getBasePackageName().replaceAll("\\.", "/") + "/" +
                generateSpec.getModuleName() + "/" + subPackageName + "/" + fileName;
        return outputFileName;
    }

    public void writeToFile(Template template, String subpackageName, String fileName) {
        String outputFileName = getFileName(subpackageName, fileName);
        File outPutFile = new File(outputFileName);
        if (outPutFile.exists() && !Boolean.TRUE.equals(generateSpec.getOverrideWhenFileExisted())) {
            throw new RuntimeException("cant generate " + outputFileName + ", because the file is already existed!");
        }

        try (FileWriter fileWriter = new FileWriter(outPutFile)) {
            template.process(generateSpec, fileWriter);
        } catch (IOException | TemplateException e) {
            log.error(e.getMessage(), e);
        }


        log.info("generate request dto file in {}", outputFileName);
    }
}
