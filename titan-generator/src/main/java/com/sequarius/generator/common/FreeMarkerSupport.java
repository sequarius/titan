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

    public void generateFrontService() throws IOException {
        Template temp = getTemplate("FrontServiceTemplate.ftl");
        writeToFrontProject(temp, "src/services/" + generateSpec.getModuleName(), generateSpec.getCamelEntityName() + ".js");
    }

    public void generateFrontModel() throws IOException {
        Template temp = getTemplate("FrontModelTemplate.ftl");
        writeToFrontProject(temp, "src/models/" + generateSpec.getModuleName(), generateSpec.getCamelEntityName() + ".js");
    }

    public void generateFrontModal() throws IOException {
        Template temp = getTemplate("FrontPageModalTemplate.ftl");
        writeToFrontProject(temp, "src/pages/" + generateSpec.getModuleName()+"/"+generateSpec.getEntityName() + "/components/" + generateSpec.getEntityName() + "Modal", "index.jsx");
    }
    public void generateFrontTable() throws IOException {
        Template temp = getTemplate("FrontPageTableTemplate.ftl");
        writeToFrontProject(temp, "src/pages/" + generateSpec.getModuleName()+"/"+generateSpec.getEntityName() + "/components/" + generateSpec.getEntityName() + "Table", "index.jsx");
    }

    public void generateFrontPage() throws IOException {
        Template temp = getTemplate("FrontPageTemplate.ftl");
        writeToFrontProject(temp, "src/pages/" + generateSpec.getModuleName()+"/"+generateSpec.getEntityName(), "index.jsx");
    }

    public void writeToFrontProject(Template template, String subPath, String fileName) {
        File frontRootDir = new File(generateSpec.getFrontProjectRoot());
        File outputFile = new File(frontRootDir, subPath + "/" + fileName);
        writeFile(template, outputFile);
    }

    private void writeFile(Template template, File outputFile) {
        if (outputFile.exists() && !Boolean.TRUE.equals(generateSpec.getOverrideWhenFileExisted())) {
            throw new RuntimeException("cant generate " + outputFile + ", because the file is already existed!");
        } else {
            outputFile.getParentFile().mkdirs();
        }
        try (FileWriter fileWriter = new FileWriter(outputFile)) {
            template.process(generateSpec, fileWriter);
        } catch (IOException | TemplateException e) {
            log.error(e.getMessage(), e);
        }


        log.info("generate template file at {}", outputFile);
    }


    public String getFileName(String subPackageName, String fileName) {
        String outputFileName = generateSpec.getProjectRoot() + "/src/main/java/" +
                generateSpec.getBasePackageName().replaceAll("\\.", "/") + "/" +
                generateSpec.getModuleName().toLowerCase() + "/" + subPackageName + "/" + fileName;
        return outputFileName;
    }

    public void writeToFile(Template template, String subpackageName, String fileName) {
        String outputFileName = getFileName(subpackageName, fileName);
        File outPutFile = new File(outputFileName);
        writeFile(template, outPutFile);
    }
}
