package com.sequarius.generator.tailend;

import com.sequarius.generator.common.FreeMarkerSupport;
import com.sequarius.generator.common.GenerateSpec;
import com.sequarius.generator.common.YamlConfigSupport;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.net.URL;
import java.net.URLClassLoader;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 06/02/2020
 */
@Slf4j
public class TailEndGenerator {
    private static volatile TailEndGenerator instance;

    public static TailEndGenerator getInstance() {
        if (instance == null) {
            synchronized (TailEndGenerator.class) {
                if (instance == null) {
                    instance = new TailEndGenerator();
                }
            }
        }
        return instance;
    }

    public void generate(ClassLoader loader, String configName, String doEntityClassName) {

        log.info("start generate file for do entity {}", doEntityClassName);
        YamlConfigSupport yamlConfigSupport = new YamlConfigSupport();
        GenerateSpec generateSpec = yamlConfigSupport.loadGenerateSpec(loader.getResourceAsStream(configName), loader, doEntityClassName);
        if (generateSpec == null) {
            log.error("cant load generateSpec,process stopped!");
            return;
        }

        FreeMarkerSupport freeMarkerSupport = new FreeMarkerSupport(generateSpec);
        try {
            freeMarkerSupport.generateResponseDTO();
            freeMarkerSupport.generateRequestDTO();
            freeMarkerSupport.generateService();
            if (!Boolean.TRUE.equals(generateSpec.getIgnoreController())) {
                freeMarkerSupport.generateController();
            }
        } catch (IOException e) {
            log.error(e.getMessage(), e);
        }
        log.info("generate {} successfully!", doEntityClassName);
    }

    public static void main(String[] args) throws Exception {
        ClassLoader classLoader = new URLClassLoader(new URL[]{
                new URL("file:///D:\\WorkSpace\\titan-sample\\titan-sample-repository\\target\\titan-sample-repository-1.0-SNAPSHOT.jar"),
                new URL("file:///D:\\WorkSpace\\titan-sample\\titan-sample-common\\target\\titan-sample-common-1.0-SNAPSHOT.jar")
        });
        TailEndGenerator.getInstance().generate(classLoader, "template.yml", "com.sequarius.titan.sample.domain.SysUserDO");

    }
}
